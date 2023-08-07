# Infrastructure For File Management App

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.11.0 |
| <a name="provider_aws.cfwaf"></a> [aws.cfwaf](#provider\_aws.cfwaf) | 5.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_sg"></a> [alb\_sg](#module\_alb\_sg) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_file_mgmt_app_ecs_sg"></a> [file\_mgmt\_app\_ecs\_sg](#module\_file\_mgmt\_app\_ecs\_sg) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_gh_actions_role"></a> [gh\_actions\_role](#module\_gh\_actions\_role) | ./modules/gh-actions-role | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | github.com/devsecops-studio/terraform-aws-vpc | v0.2.11 |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 5.1.1 |

## Resources

| Name | Type |
|------|------|
| aws_appautoscaling_policy.file_mgmt_app_cpu_scaling_policy | resource |
| aws_appautoscaling_policy.file_mgmt_app_memory_scaling_policy | resource |
| aws_appautoscaling_target.file_mgmt_app_target | resource |
| aws_cloudfront_cache_policy.main | resource |
| aws_cloudfront_distribution.main | resource |
| aws_cloudwatch_log_group.ecs_main_cluster | resource |
| aws_dynamodb_table.main | resource |
| aws_ecs_cluster.main | resource |
| aws_ecs_service.file_mgmt_app | resource |
| aws_ecs_task_definition.file_mgmt_app | resource |
| aws_iam_openid_connect_provider.github_actions | resource |
| aws_iam_role.ecs_exec_role | resource |
| aws_iam_role.file_mgmt_app_ecs_task_role | resource |
| aws_iam_role_policy.file_mgmt_app_dynamodb | resource |
| aws_iam_role_policy.file_mgmt_app_s3 | resource |
| aws_iam_role_policy_attachment.ecs_exec_role_policy | resource |
| aws_lb.main | resource |
| aws_lb_listener.file_mgmt_app | resource |
| aws_lb_target_group.file_mgmt_app | resource |
| aws_s3_bucket.main | resource |
| aws_s3_bucket_server_side_encryption_configuration.main | resource |
| aws_security_group.vpce | resource |
| aws_wafv2_web_acl.main | resource |
| aws_caller_identity.current | data source |
| aws_ec2_managed_prefix_list.cloudfront | data source |
| aws_region.current | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gh_repo_name"></a> [gh\_repo\_name](#input\_gh\_repo\_name) | Name of Github repo hosted this project. | `string` | `"nthienan/file-mgmt-app"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | `"file-mgmt-app"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where resources created | `string` | `"ap-southeast-1"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of S3 buceket. If omit, ${var.stage}-file-mgmt-app will be used | `string` | `""` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage of the project such as: dev, test, pre-prod, prod, ... | `string` | n/a | yes |
| <a name="input_vpc_cidr_prefix"></a> [vpc\_cidr\_prefix](#input\_vpc\_cidr\_prefix) | The first two octets for VPC CIDR block. eg. vpc\_cidr\_prefix="10.10" will create VPC with CIDR is 10.10.0.0/16 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The HTTP endpoint for REST APIs |
| <a name="output_gh-actions-role-arn"></a> [gh-actions-role-arn](#output\_gh-actions-role-arn) | Role ARN for deployment GitHub workflow |
<!-- END_TF_DOCS -->
