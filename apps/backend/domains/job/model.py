from sqlalchemy.orm import Mapped, mapped_column
from infrastructure.database.base import Base


class Job(Base):
    __tablename__ = "jobs"
    id: Mapped[int] = mapped_column(primary_key=True)
