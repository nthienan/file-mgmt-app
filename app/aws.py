import logging
from typing import List

import boto3
from boto3.dynamodb.conditions import Key

from app.models import FileDbItem

logger = logging.getLogger(__name__)


class AWSClient:
    def __init__(self, region) -> None:
        self.region = region


class S3Bucket(AWSClient):
    def __init__(self, name, region):
        super().__init__(region=region)
        self.name = name
        self._bucket = boto3.resource(
            "s3", region_name=self.region).Bucket(self.name)

    async def download_object(self, key: str, file_path: str):
        self._bucket.download_file(Key=key, Filename=file_path)
        logger.debug(
            f"Object \"{key}\" successfully downloaded from S3 bucket at \"{file_path}\"")

    async def upload_object(self, file: any, key: str, md5: str):
        self._bucket.upload_fileobj(
            Fileobj=file,
            Key=key,
            ExtraArgs={
                "Metadata": {
                    "md5": md5
                }
            }
        )
        logger.debug(f"Object successfully uploaded to S3 bucket at \"{key}\"")

    async def delete_object(self, key: str):
        self._bucket.delete_objects(
            Delete={
                "Objects": [{
                    "Key": key
                }]
            }
        )
        logger.debug(
            f"Object \"{key}\" successfully deleted from S3 bucket")


class DynamoDBTable(AWSClient):
    def __init__(self, name, region):
        super().__init__(region=region)
        self.name = name
        self._checksum_index_name = f"{self.name}-checksum"
        self._location_index_name = f"{self.name}-location"
        self._table = boto3.resource(
            "dynamodb", region_name=self.region).Table(self.name)

    async def get_item(self, file_name: str) -> FileDbItem:
        response = self._table.get_item(Key={"name": file_name})
        item = response["Item"] if "Item" in response else None
        if item:
            return FileDbItem.model_validate(item)
        return None

    async def check_existing(self, file_name: str) -> bool:
        response = response = self._table.query(
            KeyConditionExpression=Key("name").eq(file_name)
        )
        items = response["Items"] if "Items" in response else None
        logger.debug(f"Found {len(items)} items with name \"{file_name}\"")
        if items:
            return len(items) > 0
        return False

    async def get_duplicated_items(self, md5: str) -> List[FileDbItem]:
        """
        Get duplicated files. Duplicated means file has same md5 checksum but different name
        """
        response = self._table.query(
            IndexName=self._checksum_index_name,
            KeyConditionExpression=Key("md5").eq(md5)
        )
        items = response["Items"] if "Items" in response else []
        logger.debug(f"Found {len(items)} items with md5 \"{md5}\"")
        return [FileDbItem.model_validate(item) for item in items]

    async def get_referenced_items(self, location: str) -> List[FileDbItem]:
        """
        Get files that reference to the given location
        """
        response = self._table.query(
            IndexName=self._location_index_name,
            KeyConditionExpression=Key("location").eq(location)
        )
        items = response["Items"] if "Items" in response else []
        logger.debug(f"Found {len(items)} items with location \"{location}\"")
        return [FileDbItem.model_validate(item) for item in items]

    async def put_item(self, item: FileDbItem):
        self._table.put_item(Item=item.dict())
        logger.debug(
            f"Item successfully added to DynamoDB table at \"{self.name}\"")

    async def batch_put_items(self, items: List[FileDbItem], batch_size=25) -> None:
        with self._table.batch_writer() as batch:
            for i in range(0, len(items), batch_size):
                for item in items[i:i+batch_size]:
                    batch.put_item(Item=item.dict())

    async def delete_item(self, file_name: str) -> None:
        self._table.delete_item(Key={"name": file_name})
        logger.debug(
            f"Item successfully deleted from DynamoDB table at \"{self.name}\"")
