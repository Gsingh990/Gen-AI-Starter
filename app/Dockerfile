FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install uvicorn fastapi && \
    pip install --no-cache-dir -r requirements.txt

COPY ./src /app/src

CMD ["python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "80"]