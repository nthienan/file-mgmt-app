import logging

from fastapi import FastAPI, UploadFile

from . import handlers, models, settings
from .filters import EndpointLoggingFilter

logging.basicConfig(
    level=logging.getLevelName(settings.LOG_LEVEL.upper()),
    format="%(asctime)s.%(msecs)03d - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)

# Filter out ignored endpoints from access log
logging.getLogger("uvicorn.access").addFilter(EndpointLoggingFilter())

# Init handler
handlers.init_handler()

api = FastAPI(
    title="File Management App"
)


@api.get("/files/{file_name}")
async def get_file(file_name: str):
    """
    Endpoint for get a file by name
    :param file_name: name of file to get
    """
    return await handlers.get_file(file_name)


@api.post("/files", status_code=201, responses={
    201: {
        "description": "Successfully uploaded the file.",
        "model": models.FileItem,
    }
})
async def create_file(file: UploadFile):
    """
    Endpoint for file upload.
    :param file: file to upload.
    """
    return await handlers.create_file(file)


@api.delete("/files/{file_name}", status_code=204)
async def delete_file(file_name: str):
    """
    Endpoint for delete a file by name
    :param file_name: name of file to delete
    """
    return await handlers.delete_file(file_name)


@api.get("/-/health")
async def healthcheck() -> str:
    """
    Simple healthcheck endpoint
    :return: "ok" as a response body in plain text
    """
    return "ok"
