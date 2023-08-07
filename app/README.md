# Source Code of File Management Application

The File Management Application is a Python application built using the FastAPI framework, designed for fast development and simplicity.

**Prerequisites**:
- Python >= 3.7 installed
- [virtualenv](https://virtualenv.pypa.io/en/latest/) installed

To get started with the development of this application, follow the steps below:

1. **Create and Activate a Python Virtual Environment**

    First, create a Python virtual environment to isolate the application's dependencies:
    ```bash
    $ virtualenv .venv
    $ source .venv/bin/activate
    ```

2. **Install Application Dependencies**

    After activating the virtual environment, install the required dependencies:
    ```
    $ pip install -r app/requirements.txt
    ```

3. **Start the Application**

    Once the dependencies are installed, you can start the application with the following command:
    ```bash
    $ make app-run-dev
    ```
    This command will launch the application in development mode, allowing you to test and make changes conveniently. The application will listen on port `3000` by default. 

**Note**: Depending on your specific setup, you might need to export environment variables to configure certain settings. Please refer to [settings.py](./settings.py) to identify which environment variables are required.

Ensure that you set these environment variables properly to avoid encountering any errors during application execution.

With these instructions, you're all set to begin working on the File Management Application.

Happy coding!

For architecture design, please refer to [Architecture Design](../docs/architecture-design.md)
