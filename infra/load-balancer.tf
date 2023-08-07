locals {
  alb = {
    name = "${local.name_prefix}-ext-alb"
  }
}

resource "aws_lb" "main" {
  name               = local.alb.name
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.lb_external_subnets
  security_groups    = [module.alb_sg.security_group_id]

  tags = merge(local.tags, {
    Name = local.alb.name
  })
}

resource "aws_lb_listener" "file_mgmt_app" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.file_mgmt_app.arn
  }
}

resource "aws_lb_target_group" "file_mgmt_app" {
  name        = "${local.alb.name}-tg"
  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/-/health"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  deregistration_delay = 60

  tags = merge(local.tags, {
    Name = "${local.alb.name}-tg"
  })
}

##########################################
# Security group
##########################################
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${local.alb.name}-sg"
  description = "Security group for external ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  ingress_with_prefix_list_ids = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow inbound HTTP from CloufFront"
    },
  ]

  egress_rules = ["all-all"]

  tags = merge(local.tags, {
    Name = "${local.alb.name}-sg"
  })
}
