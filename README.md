# File Management Application

## Disclaimer

> [!WARNING]  
> This application is for demo purposes only and is **NOT ready** for production use. Please use it with caution and be aware that it is not suitable for real-world deployment at this stage.


## Features

The File Management Application is a Python application built on the FastAPI framework, providing a set of REST APIs to efficiently manage files. It offers the following features:

1. **Upload a File**

    Easily upload files to the application, securely storing them in cloud storage.

2. **Retrieve an Uploaded File by Name**

    Retrieve any previously uploaded file by specifying its name. The application will efficiently fetch the file for you.

3. **Delete an Uploaded File by Name**

    Remove any uploaded file from the storage with a simple request, freeing up space as needed.

4. **Smart File Management**

    The application has the intelligence to detect files with similar content. Instead of duplicating files, it reuses uploaded files to optimize storage space efficiently.

For details, refer to the API documentation available at https://nthienan.github.io/file-mgmt-app/

## System Design

- [Architecture design](docs/architecture-design.md)
- [CI/CD](docs/cicd.md)
- [Infrastructure deployment](docs/infra-deployment.md)


## Development

Prefer to [app/README.md](app/README.md)


## Repository Structure

For this small project, I've opted for a monorepo, which serves as a centralized repository for storing the application source code, infrastructure code for deploying the application to AWS, and the deployment pipeline, along with their respective configurations. The directory structure I've chosen promotes simplicity and ease of navigation. In the `app/` directory which houses the main application code. Additionally, a `Dockerfile` is included for containerization and a `requirements.txt` file to manage Python dependencies.

The `infra/` directory houses essential Terraform configuration files, including `variables.tf` and `provider.tf`. Additionally, within the `infra/` directory, there is a `tfvars/` subdirectory that contains corresponding Terraform variable files for each deployment environment. For instance, `tfvars/dev.tfvars` is used for the development environment, `tfvars/stag.tfvars` for the staging environment, and so on.

To streamline development and ensure consistent workflows, I've made use of GitHub Actions in the `.github/` directory. The `workflows/` subdirectory contains `wf-build-and-deploy.yaml`, which automates continuous integration and continuous deployment processes.

Additionally, the `docs/` folder contains documentation and relevant resources for the project. This includes architecture diagram, and any other documentation essential for understanding and maintaining the project.

As always, the `README.md` file provides essential project information. This structure allows me to maintain a clean and organized project.

```
.
├── Makefile
├── README.md
├── app
│   ├── Dockerfile
│   ├── README.md
│   ├── main.py
│   ├── requirements.txt
│   └── ...
├── docs
│   └── ...
└── infra
    ├── README.md
    ├── data.tf
    ├── local.tf
    ├── provider.tf
    ├── tfvars
    │   └── dev.tfvars
    ├── variables.tf
    ├── version.tf
    ├── ...
```
