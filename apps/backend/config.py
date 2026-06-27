from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "RoboRex API"
    api_prefix: str = "/api/v1"
    database_url: str = "postgresql+psycopg://postgres:postgres@postgres:5432/roborex"
    minio_endpoint: str = "minio:9000"
    minio_access_key: str = "minioadmin"
    minio_secret_key: str = "minioadmin"
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
