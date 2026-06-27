from sqlalchemy.orm import Mapped, mapped_column
from infrastructure.database.base import Base


class Prompt(Base):
    __tablename__ = "prompts"
    id: Mapped[int] = mapped_column(primary_key=True)
