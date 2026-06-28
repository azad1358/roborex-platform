.PHONY: install run test lint migrate requirements up down

install:
	uv sync

run:
	uv run uvicorn main:app --app-dir apps/backend --reload

test:
	uv run pytest

lint:
	uv run ruff check .

migrate:
	cd apps/backend && uv run --project ../.. alembic upgrade head

requirements:
	uv export --no-dev --no-hashes --output-file apps/backend/requirements.txt

up:
	docker compose --env-file docker/.env -f docker/docker-compose.yml up -d --build

down:
	docker compose --env-file docker/.env -f docker/docker-compose.yml down
