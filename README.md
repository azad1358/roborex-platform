# RoboRex Platform

AI-powered educational content generation platform.

## Repository

- `apps/backend`: FastAPI backend organized by business domain.
- `apps/studio`: reserved for the future dashboard.
- `docker`: local and production service definitions.
- `workflows`: n8n workflows, prompts, and reusable templates.
- `docs`: architecture, database, API, and deployment documentation.
- `tests`: cross-application tests.

## Development

Copy `docker/.env.example` to `docker/.env`, replace the placeholder secrets, then run:

```sh
make up
```

The backend health endpoint is available at `GET /api/v1/health`.
