import unittest
from unittest.mock import MagicMock, patch
from src.services.rag_service import RAGService
from src.models.models import Document

class TestRAGService(unittest.TestCase):

    @patch('src.services.rag_service.AzureOpenAI')
    @patch('src.services.rag_service.QdrantClient')
    def setUp(self, MockQdrantClient, MockAzureOpenAI):
        self.mock_openai_client = MockAzureOpenAI.return_value
        self.mock_qdrant_client = MockQdrantClient.return_value
        self.rag_service = RAGService()

    def test_query(self):
        # Mock the OpenAI and Qdrant client methods
        self.mock_openai_client.embeddings.create.return_value = MagicMock(
            data=[MagicMock(embedding=[0.1, 0.2, 0.3])]
        )
        self.mock_qdrant_client.search.return_value = [
            MagicMock(payload={'text': 'test document'})
        ]
        self.mock_openai_client.chat.completions.create.return_value = MagicMock(
            choices=[MagicMock(message=MagicMock(content='test response'))]
        )

        # Call the query method
        response = self.rag_service.query('test query')

        # Assert that the response is correct
        self.assertEqual(response, 'test response')

    def test_index_document(self):
        # Mock the OpenAI client method
        self.mock_openai_client.embeddings.create.return_value = MagicMock(
            data=[MagicMock(embedding=[0.1, 0.2, 0.3])]
        )

        # Call the index_document method
        document = Document(text='test document', metadata={})
        self.rag_service.index_document(document)

        # Assert that the upsert method was called with the correct arguments
        self.mock_qdrant_client.upsert.assert_called_once()

if __name__ == '__main__':
    unittest.main()