"""Regression checks for configuration isolation in full-data execution."""
import importlib.util
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("validate_notebooks", ROOT / "scripts/validate-notebooks.py")
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)


class ValidationConfigurationTests(unittest.TestCase):
    def test_run_override_preserves_other_code_and_never_executes_it(self):
        source = '''REGION_PRESET = "medium"  # normal notebook default
text = 'REGION_PRESET = "medium"'
def example():
    REGION_PRESET = "medium"
    return REGION_PRESET
OVERWRITE = True
'''
        changed = runner.assignments(source, {"REGION_PRESET": repr("large"), "OVERWRITE": "False"})
        namespace = {}
        exec(changed, namespace)
        self.assertEqual(namespace["REGION_PRESET"], "large")
        self.assertFalse(namespace["OVERWRITE"])
        self.assertEqual(namespace["example"](), "medium")
        self.assertEqual(namespace["text"], 'REGION_PRESET = "medium"')

    def test_dotenv_preserves_json_and_excludes_credentials(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / ".env").write_text(
                "MEDIUM_STATE_CODES='[\"AA\",\"BB\"]'\n"
                "SMALL_CITIES=[{\"name\":\"A B\",\"state_code\":\"AA\"}]\n"
                "S3_SECRET_KEY=not-for-validation\n"
            )
            with patch.object(runner, "ROOT", root), patch.dict(os.environ, {}, clear=True):
                config = runner.configuration()
            self.assertEqual(config["MEDIUM_STATE_CODES"], '["AA","BB"]')
            self.assertEqual(config["SMALL_CITIES"], '[{"name":"A B","state_code":"AA"}]')
            self.assertNotIn("S3_SECRET_KEY", config)

    def test_explicit_environment_overrides_dotenv_without_loading_secrets(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / ".env").write_text("MAP_FEATURE_LIMIT=2000\n")
            with patch.object(runner, "ROOT", root), patch.dict(os.environ,
                    {"MAP_FEATURE_LIMIT": "5000", "S3_ACCESS_KEY": "private"}, clear=True):
                self.assertEqual(runner.configuration(), {"MAP_FEATURE_LIMIT": "5000"})


if __name__ == "__main__":
    unittest.main()
