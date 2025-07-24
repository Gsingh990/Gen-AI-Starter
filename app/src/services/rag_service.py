from openai import OpenAI, AzureOpenAI
from qdrant_client import QdrantClient, models
from src.config.settings import settings
from src.models.models import Document

class RAGService:
    def __init__(self):
        self.openai_client = AzureOpenAI(
            api_key=settings.OPENAI_API_KEY,
            api_version="2023-07-01-preview", # Use the API version compatible with your deployment
            azure_endpoint=settings.OPENAI_ENDPOINT
        )
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
        embedding_response = self.openai_client.embeddings.create(
            input=[query_text],
            model="text-embedding-ada-002" # Ensure this matches your deployment name
        )
        embedding = embedding_response.data[0].embedding

        search_result = self.qdrant_client.search(
            collection_name="my_collection",
            query_vector=embedding,
            limit=3
        )

        context_text = ""
        for result in search_result:
            context_text += f"- {result.payload['text']}\n"

        messages = [
            {"role": "system", "content": "You are a helpful AI assistant."},
            {"role": "user", "content": f"**Context:**\n\n{context_text}\n\n**Question:** {query_text}\n\n**Answer:**"}
        ]

        chat_completion = self.openai_client.chat.completions.create(
            model="gpt-4o", # Ensure this matches your deployment name
            messages=messages,
            max_tokens=150,
            temperature=0.7,
        )
        return chat_completion.choices[0].message.content.strip()

    def index_document(self, document: Document):
        embedding_response = self.openai_client.embeddings.create(
            input=[document.text],
            model="text-embedding-ada-002" # Ensure this matches your deployment name
        )
        embedding = embedding_response.data[0].embedding

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
