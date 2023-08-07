from pydantic import BaseModel


class FileItem(BaseModel):
    name: str
    md5: str = None


class FileDbItem(FileItem):
    location: str
