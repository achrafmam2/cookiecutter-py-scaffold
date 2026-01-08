# {{cookiecutter.project_name}}

{{cookiecutter.description}}

## Requirements

- Python {{cookiecutter.python_version}}+
- [uv](https://docs.astral.sh/uv/) (recommended for dependency management)

## Installation

Install uv if you haven't already:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Clone and setup the project:

```bash
git clone <your-repo-url>
cd {{cookiecutter.project_name}}
uv sync
```

## Development

Install development dependencies:

```bash
uv sync --group dev
```

Setup pre-commit hooks:

```bash
uv run pre-commit install
```

## Code Quality

Format code:

```bash
uv run ruff format .
```

Lint code:

```bash
uv run ruff check .
```

Auto-fix linting issues:

```bash
uv run ruff check --fix .
```

## Testing

Run tests:

```bash
uv run pytest
```
