from sqlalchemy.orm import Mapped, mapped_column
from infrastructure.database.base import Base


class Script(Base):
    __tablename__ = "scripts"
    id: Mapped[int] = mapped_column(primary_key=True)
