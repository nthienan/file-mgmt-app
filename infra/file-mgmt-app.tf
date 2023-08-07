locals {
  file_mgmt_app = {
    name = "file-mgmt-app"
  }
}

##########################################
# ECS Service
##########################################
resource "aws_ecs_service" "file_mgmt_app" {
  name = "${var.stage}-${local.file_mgmt_app.name}"

  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.file_mgmt_app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.file_mgmt_app.arn
    container_name   = "app"
    container_port   = 3000
  }

  network_configuration {
    subnets         = module.vpc.ecs_subnets
    security_groups = [module.file_mgmt_app_ecs_sg.security_group_id]
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}

module "file_mgmt_app_ecs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${var.stage}-${local.file_mgmt_app.name}"
  description = "Security group for ${local.file_mgmt_app.name} ECS tasks"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [{
    from_port                = 3000
    to_port                  = 3000
    protocol                 = "tcp"
    source_security_group_id = module.alb_sg.security_group_id
    description              = "Allow ALB access"
  }]

  egress_rules = ["all-all"]
}

##########################################
# ECS Task Definition
##########################################
resource "aws_ecs_task_definition" "file_mgmt_app" {
  family = local.file_mgmt_app.name

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  task_role_arn      = aws_iam_role.file_mgmt_app_ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn

  container_definitions = templatefile("${path.module}/templates/container-definitions.tpl", {
    region         = data.aws_region.current.name
    s3_bucket      = aws_s3_bucket.main.bucket
    dynamodb_table = aws_dynamodb_table.main.name

    awslogs_group         = aws_cloudwatch_log_group.ecs_main_cluster.name
    awslogs_region        = data.aws_region.current.name
    awslogs_stream_prefix = local.file_mgmt_app.name
  })

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  tags = merge(local.tags, {
    Name = local.file_mgmt_app.name
  })
}

##########################################
# ECS Task Roles
##########################################
resource "aws_iam_role" "file_mgmt_app_ecs_task_role" {
  name        = "${var.stage}-${local.file_mgmt_app.name}-ecs-task-role"
  description = "The ECS task role for ${local.file_mgmt_app.name}"

  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
    Version = "2012-10-17"
  })

  tags = merge(local.tags, {
    Name = "${var.stage}-${local.file_mgmt_app.name}-ecs-task-role"
  })
}

resource "aws_iam_role_policy" "file_mgmt_app_dynamodb" {
  name = "dynamodb"
  role = aws_iam_role.file_mgmt_app_ecs_task_role.id
  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:BatchGetItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:PutItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
      ]
      Resource = [
        aws_dynamodb_table.main.arn,
        "${aws_dynamodb_table.main.arn}/index/*",
      ]
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy" "file_mgmt_app_s3" {
  name = "s3"
  role = aws_iam_role.file_mgmt_app_ecs_task_role.id

  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:AbortMultipartUpload",
        "s3:DeleteObject",
      ]
      Resource = [
        "${aws_s3_bucket.main.arn}/*",
      ]
    }]
    Version = "2012-10-17"
  })
}

##########################################
# Auto Scaling
##########################################
resource "aws_appautoscaling_target" "file_mgmt_app_target" {
  max_capacity       = 5
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.file_mgmt_app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  tags = local.tags
}

resource "aws_appautoscaling_policy" "file_mgmt_app_cpu_scaling_policy" {
  name               = "${var.stage}-${local.file_mgmt_app.name}-cpu-tracking-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.file_mgmt_app_target.resource_id
  scalable_dimension = aws_appautoscaling_target.file_mgmt_app_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.file_mgmt_app_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_out_cooldown = 300 # 5min
    scale_in_cooldown = 600 # 10min
  }
}

resource "aws_appautoscaling_policy" "file_mgmt_app_memory_scaling_policy" {
  name               = "${var.stage}-${local.file_mgmt_app.name}-memory-tracking-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.file_mgmt_app_target.resource_id
  scalable_dimension = aws_appautoscaling_target.file_mgmt_app_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.file_mgmt_app_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 80
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_out_cooldown = 300 # 5min
    scale_in_cooldown = 600 # 10min
  }
}
