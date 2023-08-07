locals {
  dynamodb_table = {
    name = local.name_prefix
  }
}

resource "aws_dynamodb_table" "main" {
  name         = local.dynamodb_table.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"

  global_secondary_index {
    name            = "${local.dynamodb_table.name}-checksum"
    hash_key        = "md5"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "${local.dynamodb_table.name}-location"
    hash_key        = "location"
    projection_type = "ALL"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "md5"
    type = "S"
  }

  attribute {
    name = "location"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(local.tags, {
    Name = local.dynamodb_table.name
  })
}
