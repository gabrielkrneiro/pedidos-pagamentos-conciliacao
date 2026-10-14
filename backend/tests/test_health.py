from typing import cast

from fastapi import FastAPI
from fastapi.testclient import TestClient
from sqlalchemy.exc import OperationalError

from app.db import get_session


def test_live_reports_up(client: TestClient) -> None:
    response = client.get("/health/live")

    assert response.status_code == 200
    assert response.json() == {"status": "UP"}


def test_ready_reports_up_when_database_is_reachable(client: TestClient) -> None:
    response = client.get("/health/ready")

    assert response.status_code == 200
    assert response.json() == {"status": "UP"}


def test_ready_reports_down_when_database_is_unreachable(client: TestClient) -> None:
    class UnreachableSession:
        def execute(self, *args: object) -> None:
            raise OperationalError("SELECT 1", {}, Exception("connection refused"))

    app = cast(FastAPI, client.app)
    app.dependency_overrides[get_session] = UnreachableSession
    try:
        response = client.get("/health/ready")
    finally:
        app.dependency_overrides.clear()

    assert response.status_code == 503
    assert response.json() == {"status": "DOWN"}
