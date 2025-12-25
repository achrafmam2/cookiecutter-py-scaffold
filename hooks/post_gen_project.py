from pathlib import Path


def main() -> None:
  run_agent_md_hook()


def run_agent_md_hook():
  guidelines_file = "{{cookiecutter.guidelines_file}}".strip()
  template_path = Path("agents_templ.md")
  content = template_path.read_text(encoding="utf-8")
  template_path.unlink()
  if not guidelines_file:
      return
  Path(guidelines_file).write_text(content, encoding="utf-8")


if __name__ == "__main__":
    main()
