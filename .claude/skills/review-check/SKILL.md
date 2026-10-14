---
name: review-check
description: Pre-PR gate for this repo. Reviews the current branch's changes, runs lint (Ruff) and the test suite, and reports whether the work is ready for a pull request. Use when the user asks to review, check, or validate their changes before committing or opening a PR.
---

# Review and check

Decide whether the current changes are ready for a PR. Do three things in order: find the scope, run the automated checks, review the code. Then report one verdict.

Do not change code during this skill. Report findings and offer fixes; apply them only if the user asks.

## 1. Find the scope

- Changed files: `git diff main...HEAD --stat` plus `git status --short` (uncommitted and untracked files count).
- If there are no changes, say so and stop.
- Related issue: take the number from the branch name (`feature/<n>-...`) and read it with `gh issue view <n>`, including the parent story's acceptance criteria if it has one. On `main` or without a number, ask the user which issue the work is for, or review without it.

## 2. Run the automated checks

Run `bash .claude/skills/review-check/scripts/check.sh` from the repo root (allow up to 10 minutes). It runs:

| Check | Command |
|---|---|
| Backend install | `uv sync --locked` (fails if `uv.lock` is out of date with `pyproject.toml`) |
| Backend format | `uv run ruff format --check .` |
| Backend lint | `uv run ruff check .` (rules in `backend/pyproject.toml`) |
| Backend tests | `uv run pytest` (needs Docker for Testcontainers) |
| Frontend lint and tests | `npm run lint` and `npm test`, once `frontend/package.json` exists |

For each FAIL, open its log and pull out the real cause: the failing test and assertion, the import error, or the files with format or lint violations. Format and lint failures are fixed with `uv run ruff format . && uv run ruff check --fix .` in `backend/`; mention that rather than running it.

## 3. Review the code

Read the full diff and every new file. Look for, in this order:

1. **Correctness:** bugs, wrong HTTP status codes, unhandled nulls, broken transactions, queries that ignore case or trimming when the issue requires it.
2. **Scope:** changes the issue did not ask for, and issue requirements or acceptance criteria the diff does not cover.
3. **Tests:** every new behavior and acceptance criterion has a test; tests that touch the database use the `client` fixture from `tests/conftest.py` (Testcontainers) instead of relying on a local Postgres.
4. **Project conventions:**
   - Dependencies (session, settings) reach endpoints through FastAPI `Depends`, not module-level globals.
   - Request and response bodies are Pydantic models with type hints; field-level validation errors return HTTP 422.
   - Schema changes go in a new Alembic migration; never edit a migration that is already on `main`.
   - Dependencies are added with `uv add` so `pyproject.toml` and `uv.lock` stay in sync.
5. **Security:** secrets, `.env` files, or credentials in the diff; SQL built by string concatenation.
6. **Documentation:** README or setup docs updated when behavior or setup changed.

Only report what you can point to in the diff. Mark anything you are unsure about as a question, not a finding.

## 4. Report

Keep it short:

```
Verdict: READY | NOT READY

Checks
  PASS/FAIL/SKIP lines from the script, each FAIL with its cause in one line

Findings (most severe first)
  [blocker|should-fix|nit] file:line — what is wrong and why

Acceptance criteria (if an issue was found)
  ✅/❌ each criterion, with the test or code that covers it
```

NOT READY if any check failed or was skipped for the backend, or if there is any blocker. End by offering the next step: the fixes to apply, or opening the PR with the repo's template.
