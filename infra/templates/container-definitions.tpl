[
  {
    "name": "app",
    "image": "nthienan/file-mgmt-app:latest",
    "essential": true,

    "environment": [
      {"name": "AWS_REGION", "value": "${region}"},
      {"name": "S3_BUCKET", "value": "${s3_bucket}"},
      {"name": "DYNAMODB_TABLE", "value": "${dynamodb_table}"},
      {"name": "LOG_LEVEL", "value": "INFO"}
    ],

    "portMappings": [
      {
        "containerPort": 3000
      }
    ],

    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${awslogs_group}",
        "awslogs-region": "${awslogs_region}",
        "awslogs-stream-prefix": "${awslogs_stream_prefix}"
      }
    }
  }
]
