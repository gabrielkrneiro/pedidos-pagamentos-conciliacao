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

# Backend: Spring Boot (Maven)
if [[ -f "$ROOT/backend/pom.xml" ]]; then
  run "backend lint" "$ROOT/backend" ./mvnw -B -q spotless:check
  if docker info >/dev/null 2>&1; then
    run "backend tests" "$ROOT/backend" ./mvnw -B verify
  else
    skip "backend tests" "Docker is not running; Testcontainers needs it"
    failed=1
  fi
else
  skip "backend" "no backend/pom.xml"
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
