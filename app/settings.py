import os

# common configs
LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")

# storage configs
TMP_DIR = os.environ.get("TMP_DIR", "/tmp/file-mgmt-app")

# AWS related configs
AWS_REGION = os.environ.get("AWS_REGION", "ap-southeast-1")
S3_BUCKET = os.environ.get("S3_BUCKET", "dev-file-mgmt-app")
DYNAMODB_TABLE = os.environ.get("DYNAMODB_TABLE", "dev-file-mgmt-app")
