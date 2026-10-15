from collections.abc import AsyncGenerator
from contextlib import asynccontextmanager
from pathlib import Path

from alembic import command
from alembic.config import Config
from fastapi import FastAPI

from app import health
from app.config import get_settings

ALEMBIC_INI = Path(__file__).resolve().parent.parent / "alembic.ini"


def run_migrations() -> None:
    command.upgrade(Config(str(ALEMBIC_INI)), "head")


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None]:
    run_migrations()
    yield


app = FastAPI(title=get_settings().app_name, lifespan=lifespan)
app.include_router(health.router)
