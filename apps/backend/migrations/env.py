from alembic import context
from sqlalchemy import engine_from_config, pool

from config import settings
from domains.asset.model import Asset  # noqa: F401
from domains.character.model import Character  # noqa: F401
from domains.job.model import Job  # noqa: F401
from domains.lesson.model import Lesson  # noqa: F401
from domains.prompt.model import Prompt  # noqa: F401
from domains.script.model import Script  # noqa: F401
from domains.storyboard.model import Storyboard  # noqa: F401
from infrastructure.database.base import Base

config = context.config
config.set_main_option("sqlalchemy.url", settings.database_url)
target_metadata = Base.metadata


def run_migrations_offline() -> None:
    context.configure(url=settings.database_url, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)
        with context.begin_transaction():
            context.run_migrations()


run_migrations_offline() if context.is_offline_mode() else run_migrations_online()
