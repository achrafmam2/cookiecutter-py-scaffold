#!/bin/bash

# NAME
#   test_template.sh - generate a cookiecutter project and run checks
#
# SYNOPSIS
#   ./test_template.sh [--keep]
#
# DESCRIPTION
#   Renders the template with test values, installs dependencies using uv,
#   runs formatting, linting, pytest, and pre-commit checks.
#
# OPTIONS
#   --keep  Preserve the generated project folder for inspection.

set -euo pipefail  # Exit on errors or unset vars; fail on pipeline errors

echo "🧪 Testing cookiecutter-py-scaffold template generation..."

# Parse flags
KEEP=false
if [ "${1:-}" = "--keep" ]; then
  KEEP=true
fi

# Create test workspace
TEST_DIR="$(mktemp -d -t cookiecutter-test-XXXXXX)"
mkdir -p "$TEST_DIR"
echo "📁 Test workspace: $TEST_DIR"

PROJECT_NAME="My Project"
REPO_NAME="my-project"
PACKAGE_NAME="my_folder"
CONFIG_FILE="$TEST_DIR/cookiecutter-config.yaml"
REPLAY_DIR="$TEST_DIR/.cookiecutter_replay"

echo "📦 Generating project with default values..."
mkdir -p "$REPLAY_DIR"
cat > "$CONFIG_FILE" <<EOF
default_context:
  project_name: "$PROJECT_NAME"
  repo_name: "$REPO_NAME"
  package_name: "$PACKAGE_NAME"
replay_dir: "$REPLAY_DIR"
EOF
cookiecutter . --no-input --output-dir "$TEST_DIR" --config-file "$CONFIG_FILE"

cd "$TEST_DIR/$REPO_NAME"
if [ ! -f "AGENTS.md" ]; then
  echo "❌ AGENTS.md was not generated"
  exit 1
fi

if [ ! -f "$PACKAGE_NAME/__init__.py" ]; then
  echo "❌ Expected root package '$PACKAGE_NAME' with __init__.py was not generated"
  exit 1
fi

echo "🔧 Installing uv and dependencies..."
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.cargo/bin:$PATH"
fi
uv sync --all-extras --group dev

echo "🧪 Testing pytest..."
cat > "$PACKAGE_NAME/test_basic.py" <<'PY'
def test_sanity():
    assert 1 + 1 == 2
PY
uv run pytest

echo "🎨 Formatting with ruff..."
uv run ruff format .

echo "🔍 Testing ruff lint..."
uv run ruff check .

echo "🪝 Testing pre-commit config..."
git init
git add .
uv run pre-commit install
uv run pre-commit run --all-files

echo "✅ All tests passed!"
if [ "$KEEP" = true ]; then
  echo "📁 Test project at: $TEST_DIR/$REPO_NAME"
else
  rm -rf "$TEST_DIR"
  echo "🧹 Cleaned up test workspace"
fi
