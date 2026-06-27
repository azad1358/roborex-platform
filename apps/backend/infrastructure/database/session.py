from sqlalchemy.orm import sessionmaker

from infrastructure.database.engine import engine

SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)
