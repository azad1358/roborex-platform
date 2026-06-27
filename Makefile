.PHONY: install run test lint migrate up down

install:
	pip install -r apps/backend/requirements.txt

run:
	uvicorn main:app --app-dir apps/backend --reload

test:
	pytest

lint:
	ruff check .

migrate:
	cd apps/backend && alembic upgrade head

up:
	docker compose -f docker/docker-compose.yml up -d --build

down:
	docker compose -f docker/docker-compose.yml down
