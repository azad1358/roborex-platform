from pydantic import BaseModel


class ScriptCreate(BaseModel):
    content: str
