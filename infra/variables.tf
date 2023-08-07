variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Region where resources created"
}

variable "project" {
  type        = string
  default     = "file-mgmt-app"
  description = "Project name"
}

variable "stage" {
  type        = string
  description = "Stage of the project such as: dev, test, pre-prod, prod, ..."
}

variable "vpc_cidr_prefix" {
  type = string
  description = "The first two octets for VPC CIDR block. eg. vpc_cidr_prefix=\"10.10\" will create VPC with CIDR is 10.10.0.0/16"
}

variable "s3_bucket_name" {
  type = string
  description = "Name of S3 buceket. If omit, $${var.stage}-file-mgmt-app will be used"
  default = ""
}

variable "gh_repo_name" {
  type = string
  description = "Name of Github repo hosted this project."
  default = "nthienan/file-mgmt-app"
}
