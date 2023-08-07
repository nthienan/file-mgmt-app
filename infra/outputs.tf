output "endpoint" {
  description = "The HTTP endpoint for REST APIs"
  value       = "https://${aws_cloudfront_distribution.main.domain_name}"
}

output "gh-actions-role-arn" {
  description = "Role ARN for deployment GitHub workflow"
  value       = module.gh_actions_role.iam_role_arn
}
