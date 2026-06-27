from sqlalchemy.orm import Mapped, mapped_column
from infrastructure.database.base import Base


class Lesson(Base):
    __tablename__ = "lessons"
    id: Mapped[int] = mapped_column(primary_key=True)
