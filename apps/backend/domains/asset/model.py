from sqlalchemy.orm import Mapped, mapped_column
from infrastructure.database.base import Base


class Asset(Base):
    __tablename__ = "assets"
    id: Mapped[int] = mapped_column(primary_key=True)
