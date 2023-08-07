resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = local.tags
}

module "gh_actions_role" {
  source = "./modules/gh-actions-role"

  repo               = var.gh_repo_name
  role_name          = "gh-actions-${local.name_prefix}"
  default_conditions = ["allow_master", "deny_pull_request"]

  openid_connect_provider_arn = aws_iam_openid_connect_provider.github_actions.arn

  policy_statement = {
    ecs_task_def = {
      effect = "Allow",
      actions = [
        "ecs:DescribeTaskDefinition",
        "ecs:RegisterTaskDefinition",
      ],
      resources = ["*"]
    }

    ecs_update_service = {
      effect = "Allow",
      actions = [
        "ecs:UpdateService",
      ],
      resources = [
        aws_ecs_service.file_mgmt_app.id,
      ]
      conditions = [
        {
          test     = "ArnEquals"
          variable = "ecs:cluster"
          values   = [aws_ecs_cluster.main.arn]
        },
        {
          test     = "ArnEquals"
          variable = "ecs:task-definition"
          values = [
            aws_ecs_task_definition.file_mgmt_app.arn_without_revision,
            "${aws_ecs_task_definition.file_mgmt_app.arn_without_revision}:*",
          ]
        }
      ]
    }

    iam = {
      effect   = "Allow"
      actions  = ["iam:PassRole"]
      resources = [
        aws_iam_role.ecs_exec_role.arn,
        aws_iam_role.file_mgmt_app_ecs_task_role.arn,
      ]
    }
  }

  tags = local.tags
}
