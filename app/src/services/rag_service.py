import openai
from qdrant_client import QdrantClient, models
from src.config.settings import settings
from src.models.models import Document

class RAGService:
    def __init__(self):
        openai.api_type = "azure"
        openai.api_base = settings.OPENAI_ENDPOINT
        openai.api_version = "2023-07-01-preview"
        openai.api_key = settings.OPENAI_API_KEY
        self.qdrant_client = QdrantClient(host=settings.QDRANT_HOST, port=settings.QDRANT_PORT)
        self._ensure_qdrant_collection()

    def _ensure_qdrant_collection(self):
        try:
            self.qdrant_client.get_collection(collection_name="my_collection")
        except Exception:
            self.qdrant_client.recreate_collection(
                collection_name="my_collection",
                vectors_config=models.VectorParams(size=1536, distance=models.Distance.COSINE),
            )

    def query(self, query_text: str) -> str:
        embedding = openai.Embedding.create(input=[query_text], model="text-embedding-ada-002")["data"][0]["embedding"]

        search_result = self.qdrant_client.search(
            collection_name="my_collection",
            query_vector=embedding,
            limit=3
        )

        prompt = f"""**Context:**\n\n"
        for result in search_result:
            prompt += f"- {result.payload['text']}\n"

        prompt += f"""**Question:** {query_text}\n\n**Answer:**"""

        response = openai.Completion.create(
            model="gpt-4o",
            prompt=prompt,
            max_tokens=150,
            temperature=0.7,
        )
        return response.choices[0].text.strip()

    def index_document(self, document: Document):
        embedding = openai.Embedding.create(input=[document.text], model="text-embedding-ada-002")["data"][0]["embedding"]

        self.qdrant_client.upsert(
            collection_name="my_collection",
            points=[
                models.PointStruct(
                    id=str(hash(document.text)),
                    vector=embedding,
                    payload={"text": document.text, "metadata": document.metadata}
                )
            ],
            wait=True
        )
