import hashlib
import logging
import os

from fastapi import Response, UploadFile
from fastapi.responses import JSONResponse

from . import aws, models, settings

logger = logging.getLogger(__name__)

s3_bucket = aws.S3Bucket(name=settings.S3_BUCKET, region=settings.AWS_REGION)
dynamodb_table = aws.DynamoDBTable(
    name=settings.DYNAMODB_TABLE, region=settings.AWS_REGION)


def init_handler():
    if not os.path.exists(settings.TMP_DIR):
        os.makedirs(settings.TMP_DIR)


async def get_file(file_name: str):
    file_db_item = await dynamodb_table.get_item(file_name)
    if not file_db_item:
        return JSONResponse(status_code=404, content={"message": f"File \"{file_name}\" not found"})

    local_file_path = os.path.sep.join([settings.TMP_DIR, file_name])
    await s3_bucket.download_object(key=file_db_item.location, file_path=local_file_path)

    with open(local_file_path, "rb") as file:
        response = Response(content=file.read())
        response.headers["Content-Disposition"] = f'attachment; filename="{file_name}"'
        os.remove(local_file_path)
        return response


async def create_file(file: UploadFile):
    # check if file is already existing - existing means file has same name regardless of md5 checksum
    existed = await dynamodb_table.check_existing(file.filename)
    if existed:
        message = f"File \"{file.filename}\" already existed. Please use method \"PUT\" if you want to update it."
        logger.warning(message)
        return JSONResponse(status_code=400, content={"message": message})

    md5_hash = hashlib.md5()
    # read the file in chunks to handle large files efficiently
    while content := await file.read(8192):
        md5_hash.update(content)
    # reset file pointer to the beginning for later use if any
    await file.seek(0)
    md5_checksum = md5_hash.hexdigest()

    # check if file is duplicated. if yes, then we will reference to the existing file instead of uploading it
    duplicated_items = await dynamodb_table.get_duplicated_items(md5_checksum)
    duplicated = len(duplicated_items) > 0

    location = file.filename
    if duplicated:
        location = duplicated_items[0].location
        logger.info(
            f"File \"{file.filename}\" is duplicated, it will reference to exsting file instead")
    else:
        await s3_bucket.upload_object(
            file=file.file,
            key=file.filename,
            md5=md5_checksum
        )
        logger.debug(
            f"File \"{file.filename}\" uploaded with checksum {md5_checksum}")

    # create a new file item in dynamodb
    file_db_item = models.FileDbItem(
        name=file.filename,
        md5=md5_checksum,
        location=location
    )
    await dynamodb_table.put_item(file_db_item)

    return models.FileItem(
        name=file.filename,
        md5=md5_checksum
    )


async def delete_file(file_name: str):
    file_db_item = await dynamodb_table.get_item(file_name)
    if not file_db_item:
        message = f"File \"{file_name}\" is not existed"
        logger.warning(message)
        return JSONResponse(status_code=404, content={"message": message})

    await dynamodb_table.delete_item(file_name)

    referenced_items = await dynamodb_table.get_referenced_items(file_db_item.location)
    if not referenced_items or len(referenced_items) == 0:
        await s3_bucket.delete_object(file_db_item.location)
