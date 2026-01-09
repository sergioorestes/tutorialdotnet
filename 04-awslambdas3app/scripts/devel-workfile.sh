# Tutorial awslambdas3app
# .NET commands
dotnet new solution --help
dotnet new solution --name awslambdas3app

dotnet new gitignore

# .NET AWS commands
dotnet new list --author AWS

# .NET default templates for dotnet new
dotnet new serverless.S3 --help
dotnet new serverless.S3 --name awslambdas3app --profile default --region us-west-2

# Add projects to Solution | {Ctrl}+{Shift}+P
dotnet sln awslambdas3app.sln add \
   src/awslambdas3app/awslambdas3app.csproj \
   test/awslambdas3app.Tests/awslambdas3app.Tests.csproj

# Add soluction in Solution Explorer | Open Solution
mv awslambdas3app 04-awslambdas3app

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
   --payload file://in/payload.json \
   out/response.json


aws lambda invoke \
   --profile default \
   --function-name Function \
   --cli-binary-format raw-in-base64-out \
   --payload "$(jq -c . <<EOF
{
  "Records":[
      {
         "eventVersion":"2.2",
         "eventSource":"aws:s3",
         "awsRegion":"us-west-2",
         "eventTime":"1970-01-01T00:00:00.000Z",
         "eventName":"s3Event",
         "userIdentity":{
            "principalId":"AKIA56KOIXMUXDGZN37B"
         },
         "requestParameters":{
            "sourceIPAddress":"127.0.0.1"
         },
         "responseElements":{
            "x-amz-request-id": null,
            "x-amz-id-2": null
         },
         "s3":{
            "s3SchemaVersion":"1.0",
            "configurationId":"s3EventRule",
            "bucket":{
               "name":"tutorial-04-awslambdas3app",
               "ownerIdentity":{
                  "principalId":"AKIA56KOIXMUXDGZN37B"
               },
               "arn":"arn:aws:s3:::tutorial-04-awslambdas3app"
            },
            "object":{
               "key": "text.txt",
               "size": 26,
               "eTag": "textTag",
               "versionId": null,
               "sequencer": null
            }
         }
      }
   ]
}
EOF
)" out/response.json