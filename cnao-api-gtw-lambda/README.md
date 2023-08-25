# OTel lambda Instrumentation

This sample application is a Lambda function that processes events from an API Gateway REST API. The API provides a public endpoint that you can access with a web browser or other HTTP client. When you send a request to the endpoint, the API serializes the request and sends it to the function. The function calls the Lambda API to get utilization data and returns it to the API in the required format.

:warning: The application creates a public API endpoint that is accessible over the internet. When you're done testing, run the cleanup script to delete it.

The project source includes function code and supporting resources:

- `function` - A Node.js function.
- `template.yml` - An AWS CloudFormation template that creates an application.
- `1-create-bucket.sh`, `2-deploy.sh`, etc. - Shell scripts that use the AWS CLI to deploy and manage the application.

Use the following instructions to deploy the sample application.

# Requirements
- [Node.js 10 with npm](https://nodejs.org/en/download/releases/)
- The Bash shell. For Linux and macOS, this is included by default. In Windows 10, you can install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to get a Windows-integrated version of Ubuntu and Bash.
- [The AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) v1.17 or newer.

If you use the AWS CLI v2, add the following to your [configuration file](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) (`~/.aws/config`):

```
cli_binary_format=raw-in-base64-out
```

This setting enables the AWS CLI v2 to load JSON events from a file, matching the v1 behavior.

# Setup
Download or clone this repository.

    $ git clone https://github.com/awsdocs/aws-lambda-developer-guide.git
    $ cd aws-lambda-developer-guide/sample-apps/nodejs-apig

Edit `env_otel.txt` and add your otel-collector endpoint

    AWS_LAMBDA_EXEC_WRAPPER=/opt/otel-handler,
    OTEL_EXPORTER_OTLP_ENDPOINT=<<otel_collector>>:4318,
    OTEL_LAMBDA_DISABLE_AWS_CONTEXT_PROPAGATION=true,
    OTEL_SERVICE_NAME=myservice,
    OTEL_NAMESPACE=myapplication,
    OTEL_TRACES_EXPORTER=otlp

# Deploy
To deploy the application:

    1-create-bucket.sh
    2-deploy.sh
    3-addvars_otel.sh
    4-addlayer_otel.sh


# Running
    5-get.sh

# Load Generator
    6-load.shj


# Cleanup
To delete the application, run `7-cleanup.sh`.

    nodejs-apig$ ./5-cleanup.sh
