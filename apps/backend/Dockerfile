FROM python:3.12-slim

WORKDIR /app

RUN pip install uv

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen

COPY apps/backend ./apps/backend

EXPOSE 8000

CMD ["uv", "run", "uvicorn", "main:app", "--app-dir", "apps/backend", "--host", "0.0.0.0", "--port", "8000"]
