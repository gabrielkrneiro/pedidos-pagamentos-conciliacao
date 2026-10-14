from collections.abc import Iterator

import pytest
from fastapi.testclient import TestClient
from testcontainers.community.postgres import PostgresContainer

from app.config import get_settings
from app.db import get_engine


@pytest.fixture(scope="session")
def postgres() -> Iterator[PostgresContainer]:
    with PostgresContainer("postgres:17-alpine", driver="psycopg") as container:
        yield container


@pytest.fixture
def client(postgres: PostgresContainer, monkeypatch: pytest.MonkeyPatch) -> Iterator[TestClient]:
    # Point the app at the test container instead of .env or the Docker Compose database
    monkeypatch.setenv("POSTGRES_HOST", postgres.get_container_host_ip())
    monkeypatch.setenv("POSTGRES_PORT", str(postgres.get_exposed_port(5432)))
    monkeypatch.setenv("POSTGRES_DB", postgres.dbname)
    monkeypatch.setenv("POSTGRES_USER", postgres.username)
    monkeypatch.setenv("POSTGRES_PASSWORD", postgres.password)
    get_settings.cache_clear()
    get_engine.cache_clear()

    from app.main import app

    with TestClient(app) as test_client:
        yield test_client

    get_engine().dispose()
    get_settings.cache_clear()
    get_engine.cache_clear()
