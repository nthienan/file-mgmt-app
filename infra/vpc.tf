locals {
  vpc = {
    name = "${local.name_prefix}-vpc"
  }
}

module "vpc" {
  source = "github.com/devsecops-studio/terraform-aws-vpc?ref=v0.2.11"

  name        = local.vpc.name
  cidr_prefix = var.vpc_cidr_prefix

  # subnet settings
  create_ecs_subnets = true

  # comment out the line below for high availability
  single_nat_gateway = true

  tags = local.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.1.1"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.vpce.id]

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = toset(flatten([module.vpc.default_route_table_id, module.vpc.public_route_table_ids, module.vpc.private_route_table_ids, module.vpc.ec2_public_route_table_ids, module.vpc.ec2_private_route_table_ids, module.vpc.ecs_route_table_ids, module.vpc.others_private_route_table_ids]))
      tags            = { Name = "${local.name_prefix}-s3-vpce" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = toset(flatten([module.vpc.default_route_table_id, module.vpc.public_route_table_ids, module.vpc.private_route_table_ids, module.vpc.ec2_public_route_table_ids, module.vpc.ec2_private_route_table_ids, module.vpc.ecs_route_table_ids, module.vpc.others_private_route_table_ids]))
      tags            = { Name = "${local.name_prefix}-dynamodb-vpce" }
    },
  }

  tags = local.tags
}

resource "aws_security_group" "vpce" {
  name_prefix = "${local.vpc.name}-vpce"
  description = "Default security group for VPC endpoints"

  vpc_id = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.tags,
    { Name = "${local.vpc.name}-vpce" }
  )
}
