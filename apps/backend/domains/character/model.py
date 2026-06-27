from sqlalchemy.orm import Mapped, mapped_column
from infrastructure.database.base import Base


class Character(Base):
    __tablename__ = "characters"
    id: Mapped[int] = mapped_column(primary_key=True)
