from pydantic import BaseModel


class PromptCreate(BaseModel):
    content: str
