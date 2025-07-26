from fastapi import FastAPI, APIRouter
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from src.api.routes import router
import structlog
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")

structlog.configure(
    processors=[
        structlog.processors.JSONRenderer(),
    ]
)

Instrumentator().instrument(app).expose(app)

health_router = APIRouter()

@health_router.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/")
def read_root():
    return FileResponse('static/index.html')

app.include_router(router)
app.include_router(health_router)
