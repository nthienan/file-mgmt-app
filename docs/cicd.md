# CI/CD Design

## Overall 

As this project is small and straightforward, the CI/CD process is kept simple and efficient, utilizing a GitHub workflow. The workflow consists of two main jobs, each contributing to the smooth deployment process.

1. **Building and Pushing Docker Image**: The first job focuses on building the Docker image for the application and then pushing the freshly built image to the Docker Hub container registry. By automating this step, the latest version of the application is readily available for deployment.

2. **Updating ECS Task Definition**: The second job is responsible for creating a new ECS task definition on AWS, using the updated Docker image pushed to Docker Hub in the previous step. Once the new task definition is registered, the workflow automatically updates the ECS service to adopt the new task definition. This ensures that the application runs with the latest changes and enhancements.

With this streamlined CI/CD setup, the project benefits from rapid and reliable deployments. The automated process reduces manual intervention, allowing developers to focus on enhancing the application without getting bogged down by deployment complexities

## Deep Dive 

To enable seamless interaction between the GitHub workflow and AWS services, appropriate permissions are essential. This is achieved by configuring an OpenID Connect (OIDC) identity provider (IdP) inside AWS. Subsequently, an IAM role with a trusted policy is created for this GitHub repository. Utilizing IAM roles and short-term credentials eliminates the need for long-term credentials, such as IAM user access keys, enhancing security and simplifying the CI/CD process.

The entire solution is fully automated using Terraform for this project. For detailed implementation information, refer to the following resources:

[Use IAM Roles to Connect GitHub Actions to Actions in AWS](https://aws.amazon.com/vi/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/): This resource explains how to set up IAM roles for GitHub Actions, enabling secure and seamless integration between GitHub and AWS.

[infra/cicd.tf](../infra/cicd.tf): The Terraform configuration file that automates the CI/CD setup, including the creation of IAM roles and policies for GitHub Actions.

[infra/modules/gh-actions-role](../infra/modules/gh-actions-role): The Terraform module responsible for managing the IAM role and policy for GitHub Actions.

By leveraging these automated Terraform configurations, we can confidently deploy applications to AWS from GitHub repository, while ensuring security and adhering to best practices.
