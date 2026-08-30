"""Internal helpers for the deep transportation case-study notebook."""

from __future__ import annotations

from collections import defaultdict, deque
from dataclasses import dataclass
from math import isclose
from typing import Iterable, Mapping


@dataclass(frozen=True)
class RouteTopology:
    """Bounded, driver-side topology result for a selected route."""

    assignments: tuple[dict[str, int | str], ...]
    components: tuple[dict[str, int | str | bool], ...]


def _normalise_between(value) -> tuple[float, float]:
    """Validate one Overture linear-reference range."""
    if value is None:
        return (0.0, 1.0)
    if len(value) != 2:
        raise ValueError(f"between must contain two values, found {value!r}")
    start, end = (float(value[0]), float(value[1]))
    if start < 0.0 or end > 1.0 or start >= end:
        raise ValueError(
            "between must satisfy 0 <= start < end <= 1, found "
            f"{value!r}"
        )
    return (start, end)


def _rule_boundaries(
    ranges: Iterable[object], connector_positions: Iterable[float]
) -> tuple[float, ...]:
    """Return sorted validated cut positions for presentation-only slicing."""
    positions = {0.0, 1.0}
    for value in ranges:
        positions.update(_normalise_between(value))
    for raw in connector_positions:
        position = float(raw)
        if position < 0.0 or position > 1.0:
            raise ValueError(
                f"connector position must be within [0, 1], found {raw!r}"
            )
        positions.add(position)
    return tuple(sorted(positions))


def _route_topology(rows: Iterable[Mapping[str, object]]) -> RouteTopology:
    """Build components and directed order from segment connector references.

    Geometry contact is deliberately absent from this function. Two route
    segments become adjacent only when they reference the same connector ID.
    Directed order uses connectors at ``at=0`` and ``at=1``.
    """
    segment_references: dict[str, list[tuple[str, float]]] = defaultdict(list)
    start_latitudes: dict[str, float] = {}
    end_latitudes: dict[str, float] = {}
    connector_segments: dict[str, set[str]] = defaultdict(set)

    for row in rows:
        segment_id = str(row["segment_id"])
        connector_id = str(row["connector_id"])
        position = float(row["at"])
        if position < 0.0 or position > 1.0:
            raise ValueError(
                f"connector position for {segment_id} is outside [0, 1]"
            )
        segment_references[segment_id].append((connector_id, position))
        connector_segments[connector_id].add(segment_id)
        start_latitudes[segment_id] = float(row["start_lat"])
        end_latitudes[segment_id] = float(row["end_lat"])

    if not segment_references:
        raise ValueError("route topology requires at least one segment")

    adjacency: dict[str, set[str]] = {
        segment_id: set() for segment_id in segment_references
    }
    for members in connector_segments.values():
        for segment_id in members:
            adjacency[segment_id].update(members - {segment_id})

    unvisited = set(segment_references)
    components: list[set[str]] = []
    while unvisited:
        root = min(unvisited)
        queue = deque([root])
        component = {root}
        while queue:
            current = queue.popleft()
            for neighbour in sorted(adjacency[current]):
                if neighbour not in component:
                    component.add(neighbour)
                    queue.append(neighbour)
        unvisited -= component
        components.append(component)
    components.sort(key=lambda item: (-len(item), min(item)))

    assignments: list[dict[str, int | str]] = []
    diagnostics: list[dict[str, int | str | bool]] = []
    used_labels: dict[str, int] = defaultdict(int)

    for component_number, members in enumerate(components, start=1):
        starts: dict[str, str] = {}
        ends: dict[str, str] = {}
        endpoint_valid = True
        for segment_id in members:
            start_ids = sorted(
                connector_id
                for connector_id, position in segment_references[segment_id]
                if isclose(position, 0.0, abs_tol=1e-9)
            )
            end_ids = sorted(
                connector_id
                for connector_id, position in segment_references[segment_id]
                if isclose(position, 1.0, abs_tol=1e-9)
            )
            if len(start_ids) != 1 or len(end_ids) != 1:
                endpoint_valid = False
                continue
            starts[segment_id] = start_ids[0]
            ends[segment_id] = end_ids[0]

        successors: dict[str, list[str]] = defaultdict(list)
        predecessors: dict[str, list[str]] = defaultdict(list)
        if endpoint_valid:
            by_start: dict[str, list[str]] = defaultdict(list)
            for segment_id, connector_id in starts.items():
                by_start[connector_id].append(segment_id)
            for segment_id, connector_id in ends.items():
                for successor in sorted(by_start.get(connector_id, [])):
                    if successor != segment_id and successor in members:
                        successors[segment_id].append(successor)
                        predecessors[successor].append(segment_id)

        roots = sorted(
            segment_id
            for segment_id in members
            if not predecessors.get(segment_id)
        )
        cycle_detected = False
        visit_state: dict[str, int] = {}

        def visit(segment_id: str) -> None:
            nonlocal cycle_detected
            state = visit_state.get(segment_id, 0)
            if state == 1:
                cycle_detected = True
                return
            if state == 2:
                return
            visit_state[segment_id] = 1
            for successor in successors.get(segment_id, []):
                visit(successor)
            visit_state[segment_id] = 2

        for segment_id in sorted(members):
            visit(segment_id)
        directed_path = (
            endpoint_valid
            and len(roots) == 1
            and not cycle_detected
            and all(len(value) <= 1 for value in successors.values())
            and all(len(value) <= 1 for value in predecessors.values())
        )

        ordered: list[str] = []
        if directed_path:
            current = roots[0]
            seen = set()
            while current not in seen:
                ordered.append(current)
                seen.add(current)
                next_items = successors.get(current, [])
                if not next_items:
                    break
                current = next_items[0]
            directed_path = len(ordered) == len(members)

        if not directed_path:
            ordered = sorted(
                members,
                key=lambda segment_id: (
                    start_latitudes[segment_id],
                    end_latitudes[segment_id],
                    segment_id,
                ),
            )

        latitude_delta = sum(
            end_latitudes[segment_id] - start_latitudes[segment_id]
            for segment_id in members
        )
        if latitude_delta > 1e-9:
            base_label = "northbound"
        elif latitude_delta < -1e-9:
            base_label = "southbound"
        else:
            base_label = "undetermined"
        used_labels[base_label] += 1
        direction = base_label
        if used_labels[base_label] > 1:
            direction = f"{base_label}-{used_labels[base_label]}"

        component_id = f"component-{component_number}"
        for route_order, segment_id in enumerate(ordered, start=1):
            assignments.append(
                {
                    "segment_id": segment_id,
                    "component_id": component_id,
                    "direction": direction,
                    "route_order": route_order,
                }
            )
        diagnostics.append(
            {
                "component_id": component_id,
                "direction": direction,
                "segment_count": len(members),
                "directed_path": directed_path,
                "root_count": len(roots),
                "branch_count": sum(
                    len(value) > 1 for value in successors.values()
                ),
                "cycle_detected": cycle_detected,
            }
        )

    return RouteTopology(
        assignments=tuple(sorted(assignments, key=lambda row: row["segment_id"])),
        components=tuple(diagnostics),
    )
