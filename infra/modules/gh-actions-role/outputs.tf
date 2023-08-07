output "iam_role_arn" {
  description = "ARN of created IAM role"
  value = try(aws_iam_role.this[0].arn, null)
}
