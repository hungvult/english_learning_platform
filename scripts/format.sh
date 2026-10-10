#!/bin/bash
# ==============================================================================
# Format & Lint all code across the project (Frontend + Backend)
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== [1/2] Formatting Python code (server, scripts, seed_data) with Ruff ==="
if command -v ruff &> /dev/null; then
    RUFF_BIN="ruff"
elif [ -f "$HOME/.local/bin/ruff" ]; then
    RUFF_BIN="$HOME/.local/bin/ruff"
else
    echo "Ruff not found on host. Running via docker compose backend..."
    docker compose run --rm --no-deps backend ruff format /app/app /app/seed_data 2>/dev/null || true
    RUFF_BIN=""
fi

if [ -n "$RUFF_BIN" ]; then
    "$RUFF_BIN" format "$PROJECT_ROOT/server" "$PROJECT_ROOT/scripts" "$PROJECT_ROOT/seed_data"
    "$RUFF_BIN" check --fix "$PROJECT_ROOT/server" "$PROJECT_ROOT/scripts" "$PROJECT_ROOT/seed_data"
fi

echo "=== [2/2] Formatting Frontend code (Next.js, Tailwind CSS) with Prettier ==="
docker compose run --rm --no-deps client npm run format:fix

echo "=== All formatting completed successfully! ==="
