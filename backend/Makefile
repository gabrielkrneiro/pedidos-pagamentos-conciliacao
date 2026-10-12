.PHONY: run sync add-dependency add-dependencies-dev remove-dependency

run:
	uv run uvicorn app.main:app --reload --port 8080

sync:
	uv sync

# make add-dependency name=httpx        or  name="httpx>=0.28"
add-dependency:
	uv add $(name)

# make add-dependencies-dev dependencies="pytest-cov mypy"
add-dependencies-dev:
	uv add --dev $(dependencies)

# make remove-dependency name=httpx
remove-dependency:
	uv remove $(name)

up-database-dev:
	docker compose up -d postgres