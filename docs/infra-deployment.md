## Infrastructure Deployment

This documentation aims to guide you through the process of deploying the entire infrastructure as described in the [Archiecture Design](./architecture-design.md).

**Prerequisites**:
- Terraform >= >= 1.5.0 installed.
- Appropriate AWS permissions to create and configure resources.

Follow the steps below to deploy the infrastructure:

1. **Modify the Terraform Variables**: Begin by modifying the [infra/tfvars/dev.tfvars](../infra/tfvars/dev.tfvars) file to update the Terraform variable values according to your environment requirements. You may also create a new file for custom configurations if needed.

2. **Initialize Terraform**: Run the following command to initialize Terraform and install the necessary providers and modules:
    ```bash
    $ make tf-init
    ```

3. **Generate Terraform Plan**: Generate the Terraform execution plan to preview the changes that will be applied to the infrastructure:
    ```bash
    $ make tf-plan STAGE=dev
    ```

4. **Deploy Infrastructure**: To deploy the infrastructure, execute the following command:
    ```bash
    $ make tf-apply STAGE=dev
    ```

> [!WARNING]  
> For the sake of simplicity in setting up Terraform and deploying the infrastructure, this project uses a local backend to store the tfstate, which is **NOT recommended** for real-world applications or production use. It is strongly advised to use a secure remote backend, such as S3, for storing the tfstate instead.

By following these steps, you can quickly deploy the infrastructure required for the project.
