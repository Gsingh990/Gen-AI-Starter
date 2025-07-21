## Application Configuration

The RAG Chatbot application uses environment variables for configuration, managed via Pydantic's `BaseSettings`. These variables are typically set in the Kubernetes deployment manifest.

*   `OPENAI_API_KEY`: Your Azure OpenAI API key.
*   `OPENAI_ENDPOINT`: Your Azure OpenAI endpoint (e.g., `https://<your-openai-account>.openai.azure.com/`).
*   `QDRANT_HOST`: The hostname or IP address of the Qdrant service (default: `qdrant`).
*   `QDRANT_PORT`: The port of the Qdrant service (default: `6333`).

## Local Development

To set up the RAG Chatbot application for local development:

1.  **Prerequisites:**
    *   Python 3.9+
    *   Docker Desktop (for local Qdrant)

2.  **Install Dependencies:**

    ```bash
    cd app
    pip install -r requirements.txt
    ```

3.  **Run Local Qdrant (Docker):**

    ```bash
    docker run -p 6333:6333 -p 6334:6334 qdrant/qdrant
    ```

4.  **Create `.env` file:**

    Create a `.env` file in the `app/src` directory with your Azure OpenAI credentials:

    ```
    OPENAI_API_KEY="YOUR_OPENAI_API_KEY"
    OPENAI_ENDPOINT="YOUR_OPENAI_ENDPOINT"
    ```

5.  **Run the FastAPI Application:**

    ```bash
    uvicorn src.main:app --reload
    ```

    The API will be available at `http://127.0.0.1:8000`.

## Contributing

We welcome contributions to enhance this GenAI Starter Stack. Please follow these guidelines:

*   Fork the repository.
*   Create a new branch for your feature or bug fix.
*   Ensure your code adheres to existing style and quality standards.
*   Write clear and concise commit messages.
*   Submit a pull request with a detailed description of your changes.