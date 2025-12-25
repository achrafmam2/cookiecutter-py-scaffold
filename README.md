# cookiecutter-py-scaffold

A minimal, generic Python project template with modern tooling.

## Features

- **uv** for fast, reliable dependency management
- **ruff** for linting and formatting
- **pytest** for testing
- **pre-commit** hooks for code quality
- **GitHub Actions** for CI/CD
- Flat project structure - no enforced layout
- Tests alongside source code (`*_test.py` pattern)

## Usage

Install cookiecutter:

```bash
pip install cookiecutter
# or
uv tool install cookiecutter
```

Generate a new project:

```bash
cookiecutter gh:achrafmam2/cookiecutter-py-scaffold
```

## What You Get

A project with:

- `pyproject.toml` configured for uv, ruff, and pytest
- Pre-commit hooks setup
- GitHub Actions for tests and linting
- No enforced directory structure - add your code however you like
- Tests excluded from package distribution

## Philosophy

This template provides the **scaffolding**, not the structure. It sets up:

- Modern Python tooling
- Code quality automation
- CI/CD basics

But it doesn't enforce:

- Where you put your code
- How you organize modules
- What kind of project you're building (library, API, ML, etc.)

You get the boilerplate; you design the architecture.

## Development

After generating a project:

1. Install dependencies: `uv sync --all-extras`
2. Setup pre-commit: `uv run pre-commit install`
3. Start coding!
