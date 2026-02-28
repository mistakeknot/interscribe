"""Tests for interscribe skill structure."""

from pathlib import Path

from helpers import parse_frontmatter


SKILLS_DIR = Path(__file__).resolve().parent.parent.parent / "skills"
SKILL_DIRS = sorted(
    d for d in SKILLS_DIR.iterdir()
    if d.is_dir() and (d / "SKILL.md").exists()
)


def test_skill_count(skills_dir):
    """Total skill count matches expected value."""
    dirs = sorted(
        d for d in skills_dir.iterdir()
        if d.is_dir() and (d / "SKILL.md").exists()
    )
    assert len(dirs) == 1, (
        f"Expected 1 skill, found {len(dirs)}: {[d.name for d in dirs]}"
    )


def test_skill_has_frontmatter():
    """interscribe SKILL.md has valid YAML frontmatter with 'name' and 'description'."""
    skill_md = SKILLS_DIR / "interscribe" / "SKILL.md"
    fm, _ = parse_frontmatter(skill_md)
    assert fm is not None, "SKILL.md has no frontmatter"
    assert "name" in fm, "SKILL.md frontmatter missing 'name'"
    assert "description" in fm, "SKILL.md frontmatter missing 'description'"


def test_skill_name_matches():
    """Skill name in frontmatter matches directory name."""
    skill_md = SKILLS_DIR / "interscribe" / "SKILL.md"
    fm, _ = parse_frontmatter(skill_md)
    assert fm["name"] == "interscribe", f"Skill name mismatch: {fm['name']}"


def test_skill_has_argument_hint():
    """SKILL.md frontmatter includes argument-hint for mode selection."""
    skill_md = SKILLS_DIR / "interscribe" / "SKILL.md"
    fm, _ = parse_frontmatter(skill_md)
    assert "argument-hint" in fm, "SKILL.md frontmatter missing 'argument-hint'"
