#!/bin/bash
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

echo "📦 Generating project with default values..."
cookiecutter . --no-input --output-dir "$TEST_DIR"

cd "$TEST_DIR/my_project"

echo "🔧 Installing uv and dependencies..."
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.cargo/bin:$PATH"
fi
uv sync --all-extras

echo "🎨 Formatting with ruff..."
uv run ruff format .

echo "🔍 Testing ruff lint..."
uv run ruff check .

echo "🧪 Testing pytest..."
uv run pytest || [ $? -eq 5 ]

echo "🪝 Testing pre-commit config..."
git init
git add .
uv run pre-commit install
uv run pre-commit run --all-files

echo "✅ All tests passed!"
if [ "$KEEP" = true ]; then
  echo "📁 Test project at: $TEST_DIR/my_project"
else
  rm -rf "$TEST_DIR"
  echo "🧹 Cleaned up test workspace"
fi
