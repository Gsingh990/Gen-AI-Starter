from pydantic import BaseModel

class Query(BaseModel):
    text: str

class Document(BaseModel):
    text: str
    metadata: dict
