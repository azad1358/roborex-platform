from sqlalchemy.orm import Mapped, mapped_column
from infrastructure.database.base import Base


class Storyboard(Base):
    __tablename__ = "storyboards"
    id: Mapped[int] = mapped_column(primary_key=True)
