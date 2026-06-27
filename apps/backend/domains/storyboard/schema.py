from pydantic import BaseModel


class StoryboardCreate(BaseModel):
    title: str
