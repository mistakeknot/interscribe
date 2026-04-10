"""Tests for plugin structure."""

import sys
from pathlib import Path

# Add interverse/ to path so _shared package is importable
_interverse = Path(__file__).resolve().parents[3]
if str(_interverse) not in sys.path:
    sys.path.insert(0, str(_interverse))

from _shared.tests.structural.test_base import StructuralTests


class TestStructure(StructuralTests):
    """Structural tests -- inherits shared base, adds plugin-specific checks."""

    def test_plugin_name(self, plugin_json):
        assert plugin_json["name"] == "interscribe"

    def test_required_root_files(self, project_root):
        """All required root-level files exist (interscribe stricter set)."""
        required = [
            "README.md",
            "CLAUDE.md",
            "AGENTS.md",
            "PHILOSOPHY.md",
            "LICENSE",
            ".gitignore",
        ]
        for name in required:
            assert (project_root / name).exists(), f"Missing required file: {name}"

    def test_scripts_count(self, project_root):
        """Expected number of scripts."""
        scripts_dir = project_root / "scripts"
        if not scripts_dir.is_dir():
            assert False, "Expected scripts/ directory"
            return
        scripts = list(scripts_dir.glob("*.sh"))
        assert len(scripts) == 3, (
            f"Expected 3 scripts, found {len(scripts)}: {[s.name for s in scripts]}"
        )
