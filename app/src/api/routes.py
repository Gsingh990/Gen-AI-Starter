from fastapi import APIRouter, Depends
from src.models.models import Query, Document
from src.services.rag_service import RAGService

router = APIRouter()

def get_rag_service():
    return RAGService()

@router.post("/query/")
def query_rag(query: Query, rag_service: RAGService = Depends(get_rag_service)):
    return {"response": rag_service.query(query.text)}

@router.post("/index/")
def index_document(document: Document, rag_service: RAGService = Depends(get_rag_service)):
    rag_service.index_document(document)
    return {"status": "success"}
