from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    
    QDRANT_HOST: str = "qdrant"
    QDRANT_PORT: int = 6333

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"

settings = Settings()
