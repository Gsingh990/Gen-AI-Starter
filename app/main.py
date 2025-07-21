from fastapi import FastAPI
from pydantic import BaseModel
import openai
from qdrant_client import QdrantClient, models

app = FastAPI()

# --- Configuration ---
OPENAI_API_KEY = "YOUR_OPENAI_API_KEY"  # Replace with your actual key
OPENAI_ENDPOINT = "YOUR_OPENAI_ENDPOINT" # Replace with your actual endpoint
QDRANT_HOST = "qdrant" # This will be the name of the Qdrant service in Kubernetes
QDRANT_PORT = 6333

# --- OpenAI Client ---
openai.api_type = "azure"
openai.api_base = OPENAI_ENDPOINT
openai.api_version = "2023-07-01-preview"
openai.api_key = OPENAI_API_KEY

# --- Qdrant Client ---
qdrant_client = QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)

# --- Data Models ---
class Query(BaseModel):
    text: str

class Document(BaseModel):
    text: str
    metadata: dict

# --- API Endpoints ---
@app.post("/query/")
def query_rag(query: Query):
    """Receives a query, retrieves relevant documents from Qdrant, and generates a response using OpenAI."""

    # 1. Embed the query
    embedding = openai.Embedding.create(input=[query.text], model="text-embedding-ada-002")["data"][0]["embedding"]

    # 2. Search for similar documents in Qdrant
    search_result = qdrant_client.search(
        collection_name="my_collection",
        query_vector=embedding,
        limit=3
    )

    # 3. Augment the prompt with the retrieved documents
    prompt = f"""**Context:**

"
    for result in search_result:
        prompt += f"- {result.payload['text']}\n"

    prompt += f"""**Question:** {query.text}

**Answer:**"""

    # 4. Generate a response using OpenAI
    response = openai.Completion.create(
        model="gpt-4o",
        prompt=prompt,
        max_tokens=150,
        temperature=0.7,
    )

    return {"response": response.choices[0].text.strip()}

@app.post("/index/")
def index_document(document: Document):
    """Indexes a new document in the Qdrant vector database."""

    # 1. Embed the document
    embedding = openai.Embedding.create(input=[document.text], model="text-embedding-ada-002")["data"][0]["embedding"]

    # 2. Index the document in Qdrant
    qdrant_client.upsert(
        collection_name="my_collection",
        points=[
            models.PointStruct(
                id=str(hash(document.text)), # Simple ID generation
                vector=embedding,
                payload={"text": document.text, "metadata": document.metadata}
            )
        ],
        wait=True
    )

    return {"status": "success"}

@app.on_event("startup")
def startup_event():
    """Creates the Qdrant collection on startup if it doesn't exist."""
    try:
        qdrant_client.get_collection(collection_name="my_collection")
    except Exception:
        qdrant_client.recreate_collection(
            collection_name="my_collection",
            vectors_config=models.VectorParams(size=1536, distance=models.Distance.COSINE),
        )
