"""Scratch-space accounting for the host-mounted Docker work directory."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from pathlib import Path
import shutil

from .config import LabSettings


GIB = 1024**3


@dataclass(frozen=True)
class ScratchStatus:
    path: str
    namespace_used_gib: float
    filesystem_free_gib: float
    budget_gib: int
    reserve_gib: int
    usable_budget_gib: int

    def as_dict(self) -> dict[str, object]:
        return asdict(self)


def _tree_bytes(root: Path) -> int:
    total = 0
    for path in root.rglob("*"):
        try:
            if path.is_file():
                total += path.stat().st_size
        except FileNotFoundError:
            # Spark may remove a spill file while status is being collected.
            continue
    return total


def scratch_status(settings: LabSettings, *, enforce: bool = True) -> ScratchStatus:
    """Return scratch usage and enforce the configured soft safety boundary.

    Docker Desktop bind mounts do not expose a portable per-directory quota.
    This check therefore guards the lab namespace before work begins; it does
    not pretend to be a filesystem-enforced hard quota.
    """
    root = Path(settings.scratch_dir)
    root.mkdir(parents=True, exist_ok=True)
    usage = shutil.disk_usage(root)
    namespace_used = _tree_bytes(root)
    usable_budget = settings.scratch_budget_gb - settings.scratch_reserve_gb
    status = ScratchStatus(
        path=str(root),
        namespace_used_gib=round(namespace_used / GIB, 3),
        filesystem_free_gib=round(usage.free / GIB, 3),
        budget_gib=settings.scratch_budget_gb,
        reserve_gib=settings.scratch_reserve_gb,
        usable_budget_gib=usable_budget,
    )
    if enforce and namespace_used > usable_budget * GIB:
        raise RuntimeError(
            f"Scratch namespace {root} uses {status.namespace_used_gib} GiB; "
            f"the safe limit is {usable_budget} GiB. Clean it explicitly "
            "before continuing."
        )
    if enforce and usage.free < settings.scratch_reserve_gb * GIB:
        raise RuntimeError(
            f"Scratch filesystem has {status.filesystem_free_gib} GiB free; "
            f"at least {settings.scratch_reserve_gb} GiB must remain free."
        )
    return status
