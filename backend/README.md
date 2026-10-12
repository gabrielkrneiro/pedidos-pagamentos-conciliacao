# Backend

FastAPI application for the Orders, Payments, and Reconciliation platform. It exposes the REST API, owns the PostgreSQL schema through Alembic migrations, and contains the backend tests.

> **Status:** bootstrapped ([#7](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/7)). The application starts and exposes a health endpoint; business endpoints are not implemented yet.

## Tech stack

| Concern       | Technology                              |
| ------------- | --------------------------------------- |
| Language      | Python 3.14                             |
| Framework     | FastAPI (Pydantic for validation)       |
| Package manager | uv                                    |
| Database      | PostgreSQL, through SQLAlchemy 2 and psycopg 3 |
| Migrations    | Alembic                                 |
| Lint and format | Ruff                                  |
| Tests         | pytest, FastAPI `TestClient`, Testcontainers |

## Layout

```text
backend/
├── app/
│   ├── main.py     # FastAPI application and router registration
│   ├── config.py   # Settings loaded from env vars and .env
│   ├── db.py       # SQLAlchemy engine and per-request session dependency
│   └── health.py   # GET /health/live and /health/ready
├── tests/          # pytest suite; conftest.py starts PostgreSQL with Testcontainers
├── Makefile        # shortcuts for the commands below
├── mise.toml       # Python and uv versions
└── pyproject.toml  # dependencies and Ruff/pytest config (uv.lock pins versions)
```

## Planned work

- Docker Compose for the API and PostgreSQL ([#6](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/6))
- Alembic configuration ([#8](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/8))
- Customer data model, documented in `docs/data-model.md` ([#9](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/9))
- Customers table migration ([#10](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/10))
- `POST /customers` and `GET /customers` endpoints ([#11](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/11), [#12](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/12))
- API tests for customer endpoints ([#13](https://github.com/gabrielkrneiro/pedidos-pagamentos-conciliacao/issues/13))

## Getting started

### Prerequisites

- [mise](https://mise.jdx.dev), with `eval "$(mise activate zsh)"` (or your shell's equivalent) in your shell config
- Docker, for the local database and for the tests

The two tools have separate jobs:

- **mise** installs the Python and uv versions pinned in `mise.toml` and switches to them when you `cd` into `backend/`. Other projects on the same machine can pin different versions.
- **uv** manages this project's dependencies in its own `.venv`, from `pyproject.toml` and `uv.lock`. `uv run <command>` uses that environment, so you never need to activate it.

### First-time setup

```bash
cd backend
mise install                # installs Python 3.14 and uv
make sync                   # uv sync: creates .venv and installs dependencies
cp .env.example .env        # then set POSTGRES_PASSWORD
```

### Run the API

```bash
docker compose up -d        # starts PostgreSQL
make run                    # uv run uvicorn app.main:app --reload --port 8080
```

Check that it is up:

- `curl http://localhost:8080/health/live` (liveness) returns `{"status":"UP"}` while the process is running. It doesn't touch the database, so use it for container healthchecks and restarts.
- `curl http://localhost:8080/health/ready` (readiness) returns `{"status":"UP"}` when the API can serve traffic, or HTTP 503 with `{"status":"DOWN"}` when the database is unreachable.

Interactive API docs are at http://localhost:8080/docs.

Stop the database with `docker compose down` (add `-v` to also delete its data).

### Run the tests

```bash
uv run pytest               # whole suite
uv run pytest -v            # list each test
uv run pytest tests/test_health.py -k up   # one file or test
```

The tests start their own PostgreSQL container with Testcontainers, so they don't need `.env` or the Docker Compose database, but Docker must be running.

### Manage dependencies

Always add dependencies through uv so `pyproject.toml` and `uv.lock` stay in sync, and commit both files. Never `pip install` into the project.

| Task | Make target | uv command |
| ---- | ----------- | ---------- |
| Install from the lockfile | `make sync` | `uv sync` |
| Add a dependency | `make add-dependency name="httpx>=0.28"` | `uv add "httpx>=0.28"` |
| Add dev dependencies | `make add-dependencies-dev dependencies="pytest-cov mypy"` | `uv add --dev pytest-cov mypy` |
| Remove a dependency | `make remove-dependency name=httpx` | `uv remove httpx` |

### Formatting and lint

Python code follows Ruff's formatter (100-column lines) and the lint rules in `pyproject.toml`. VS Code applies them on save through `.vscode/settings.json`.

```bash
uv run ruff format . && uv run ruff check --fix .         # fix
uv run ruff format --check . && uv run ruff check .       # check only
```

To run every check before opening a PR (install, format, lint, and tests), run `bash .claude/skills/review-check/scripts/check.sh` from the repository root.

### Troubleshooting

- **`uv: command not found`:** mise is not active in your shell. Add `eval "$(mise activate zsh)"` to `~/.zshrc`, or prefix commands with `mise exec --`.
- **`[Errno 48] Address already in use` on port 8080:** another process is listening on 8080. Find it with `sudo lsof -nP -iTCP:8080 -sTCP:LISTEN`, or run on another port: `uv run uvicorn app.main:app --reload --port 8000`.
- **Tests fail with a Docker connection error:** Docker is not running. With Docker Desktop on macOS, if it is running and the tests still can't reach it, export `DOCKER_HOST=unix://$HOME/.docker/run/docker.sock`. Docker Desktop runs for only one macOS user at a time; if it won't start, quit it in the other user's session.
- **Wrong Python version:** run `mise ls` inside `backend/` and check that Python 3.14 is active. An active conda environment (`(base)` in the prompt) can shadow it outside the project; `uv run` is not affected.
