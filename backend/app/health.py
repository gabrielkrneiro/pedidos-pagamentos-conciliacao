from typing import Annotated, Literal

from fastapi import APIRouter, Depends, Response, status
from pydantic import BaseModel
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from app.db import get_session

router = APIRouter()


class Health(BaseModel):
    status: Literal["UP", "DOWN"]


@router.get("/health/live")
def live() -> Health:
    return Health(status="UP")


@router.get("/health/ready")
def ready(session: Annotated[Session, Depends(get_session)], response: Response) -> Health:
    try:
        session.execute(text("SELECT 1"))
    except SQLAlchemyError:
        response.status_code = status.HTTP_503_SERVICE_UNAVAILABLE
        return Health(status="DOWN")
    return Health(status="UP")
