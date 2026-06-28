from fastapi import FastAPI

from api import asset, character, health, job, lesson, prompt
from config import settings

app = FastAPI(title=settings.app_name, version="0.1.0")

for router in (
    health.router,
    lesson.router,
    asset.router,
    character.router,
    prompt.router,
    job.router,

):
    app.include_router(router, prefix=settings.api_prefix)
