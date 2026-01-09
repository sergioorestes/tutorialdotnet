# Tutorial awslambdas3mockapp
# .NET commands
dotnet new solution --help
dotnet new solution --name awslambdas3mockapp

# Create gitignore file
dotnet new gitignore

# .NET AWS commands
dotnet new list --author AWS

# .NET default templates for dotnet new
dotnet new lambda.S3 --help
dotnet new lambda.S3 --name awslambdas3mockapp --profile default --region us-west-2

# Add projects to Solution | {Ctrl}+{Shift}+P
dotnet sln awslambdas3mockapp.sln add \
    src/awslambdas3mockapp/awslambdas3mockapp.csproj \
    test/awslambdas3mockapp.Tests/awslambdas3mockapp.Tests.csproj

# Add soluction in Solution Explorer | Open Solution
mv awslambdas3mockapp 05-awslambdas3mockapp

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


