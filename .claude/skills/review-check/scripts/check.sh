#!/usr/bin/env bash
# Runs lint and tests for every part of the monorepo that exists.
# Prints one PASS/FAIL/SKIP line per check and exits non-zero if any check failed.
# Full output of each check is saved under $LOG_DIR.

set -uo pipefail

ROOT="$(git rev-parse --show-toplevel)"
LOG_DIR="${LOG_DIR:-$(mktemp -d)}"
failed=0
results=()

run() {
  local name="$1" dir="$2"
  shift 2
  local log="$LOG_DIR/${name// /-}.log"
  echo "▶ $name"
  if (cd "$dir" && "$@") >"$log" 2>&1; then
    results+=("PASS  $name")
  else
    results+=("FAIL  $name  (log: $log)")
    failed=1
  fi
}

skip() {
  results+=("SKIP  $1  ($2)")
}

# Backend: FastAPI (uv)
if [[ -f "$ROOT/backend/pyproject.toml" ]]; then
  # uv comes from backend/mise.toml; this non-interactive shell has no mise activation
  uv=(uv)
  command -v uv >/dev/null 2>&1 || uv=(mise exec -C "$ROOT/backend" -- uv)
  run "backend install" "$ROOT/backend" "${uv[@]}" sync --locked
  run "backend format" "$ROOT/backend" "${uv[@]}" run ruff format --check .
  run "backend lint" "$ROOT/backend" "${uv[@]}" run ruff check .
  if docker info >/dev/null 2>&1; then
    run "backend tests" "$ROOT/backend" "${uv[@]}" run pytest
  else
    skip "backend tests" "Docker is not running; Testcontainers needs it"
    failed=1
  fi
else
  skip "backend" "no backend/pyproject.toml"
fi

# Frontend: Angular (npm), once it exists
if [[ -f "$ROOT/frontend/package.json" ]]; then
  [[ -d "$ROOT/frontend/node_modules" ]] || run "frontend install" "$ROOT/frontend" npm ci
  run "frontend lint" "$ROOT/frontend" npm run lint --if-present
  run "frontend tests" "$ROOT/frontend" npm test --if-present -- --watch=false
else
  skip "frontend" "no frontend/package.json yet"
fi

echo
echo "Results (logs in $LOG_DIR):"
printf '  %s\n' "${results[@]}"
exit "$failed"
