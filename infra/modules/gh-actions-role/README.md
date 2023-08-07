# Terraform Module For GitHub Actions Role

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.additional_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.additional_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_ids"></a> [account\_ids](#input\_account\_ids) | Root users of these Accounts (id) would be given the permissions to assume the role created by this module. | `list(string)` | `[]` | no |
| <a name="input_conditions"></a> [conditions](#input\_conditions) | (Optional) Additonal conditions for checking the OIDC claim. | <pre>list(object({<br>    test     = string<br>    variable = string<br>    values   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_custom_principal_arns"></a> [custom\_principal\_arns](#input\_custom\_principal\_arns) | List of IAM principals ARNs able to assume the role created by this module. | `list(string)` | `[]` | no |
| <a name="input_default_conditions"></a> [default\_conditions](#input\_default\_conditions) | (Optional) Default condtions to apply, at least one of the following is madatory: 'allow\_main', 'allow\_environment', 'deny\_pull\_request' and 'allow\_all'. | `list(string)` | <pre>[<br>  "allow_main",<br>  "deny_pull_request"<br>]</pre> | no |
| <a name="input_github_environments"></a> [github\_environments](#input\_github\_environments) | (Optional) Allow GitHub action to deploy to all (default) or to one of the environments in the list. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_github_oidc_issuer"></a> [github\_oidc\_issuer](#input\_github\_oidc\_issuer) | OIDC issuer for GitHub Actions | `string` | `"token.actions.githubusercontent.com"` | no |
| <a name="input_openid_connect_provider_arn"></a> [openid\_connect\_provider\_arn](#input\_openid\_connect\_provider\_arn) | Set the openid connect provider ARN when the provider is not managed by the module. | `string` | n/a | yes |
| <a name="input_policy_statement"></a> [policy\_statement](#input\_policy\_statement) | Map of dynamic policy statements to attach to IAM role | `any` | `{}` | no |
| <a name="input_repo"></a> [repo](#input\_repo) | (Optional) GitHub repository to grant access to assume a role via OIDC. When the repo is set, a role will be created. | `string` | `null` | no |
| <a name="input_role_max_session_duration"></a> [role\_max\_session\_duration](#input\_role\_max\_session\_duration) | Maximum session duration (in seconds) that you want to set for the specified role. | `number` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | (Optional) role name of the created role, if not provided the `namespace` will be used. | `string` | `null` | no |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | (Optional) Path for the created role, requires `repo` is set. | `string` | `"/gh-actions/"` | no |
| <a name="input_role_permissions_boundary"></a> [role\_permissions\_boundary](#input\_role\_permissions\_boundary) | (Optional) Boundary for the created role, requires `repo` is set. | `string` | `null` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | List of ARNs of IAM policies to attach to IAM role | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags that applied for all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of created IAM role |
<!-- END_TF_DOCS -->
