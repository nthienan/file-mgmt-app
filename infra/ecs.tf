locals {
  ecs = {
    cluster_name = local.name_prefix
  }
}

resource "aws_ecs_cluster" "main" {
  name = local.ecs.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(local.tags, {
    Name = local.ecs.cluster_name
  })
}

resource "aws_cloudwatch_log_group" "ecs_main_cluster" {
  name              = "/aws/ecs/${local.ecs.cluster_name}"
  retention_in_days = 30

  tags = merge(local.tags, {
    Name = local.ecs.cluster_name
  })
}

##########################################
# ECS Task Roles
##########################################
resource "aws_iam_role" "ecs_exec_role" {
  name        = "${local.name_prefix}-ecs-exec-role"
  description = "The shared ECS execution role"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
    Version = "2012-10-17"
  })

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ecs-exec-role"
  })
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_policy" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
