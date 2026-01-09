# Tutorial awslambdaapp
# .NET commands
dotnet new solution --help
dotnet new solution --name awslambdaapp

dotnet new gitignore

# Add projects to Solution | {Ctrl}+{Shift}+P
dotnet sln awslambdaapp.sln add \
    src/awslambdaapp/awslambdaapp.csproj \
    test/awslambdaapp.Tests/awslambdaapp.Tests.csproj

# Add soluction in Solution Explorer | Open Solution
mv awslambdaapp 03-awslambdaapp

# .NET AWS commands
# Add soluction in Solution Explorer | Open Solution
dotnet new list --author AWS

dotnet new install Amazon.Lambda.Templates

# Installing and updating the CLI tools
dotnet tool install -g Amazon.Lambda.Tools
dotnet tool update -g Amazon.Lambda.Tools

# .NET default templates for dotnet new
dotnet new lambda.EmptyFunction --help
dotnet new lambda.EmptyFunction --name awslambdaapp --profile default --region us-west-2

# Nuget packages
dotnet add package AWSSDK.Core --version 3.7.400.13
dotnet add package AWSSDK.Lambda --version 3.7.402.3

# Deploying an AWS Lambda Project with the .NET Core CLI
dotnet lambda --help
dotnet lambda deploy-function --help

sudo chmod 0755 deploy-lambda.sh

# Invoke Lambda .NET Core CLI
aws lambda invoke \
    --profile default \
    --function-name Function \
    --cli-binary-format raw-in-base64-out \
    --payload '{ "text": "hello world" }' \
    out/response.json
