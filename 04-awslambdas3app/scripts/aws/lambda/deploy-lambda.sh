#!/bin/bash

dotnet lambda deploy-function \
    --function-name Function \
    --function-description Description\ Function \
    --region us-west-2 \
    --profile default \
    --project-location ../../../src/awslambdas3app \
    --configuration Release \
    --framework net8.0 \
    --function-runtime dotnet8 \
    --function-memory-size 256 \
    --ephemerals-storage-size 512 \
    --function-timeout 30 \
    --function-handler awslambdas3app::awslambdas3app.Function::FunctionHandler \
    --function-role arn:aws:iam::958478727977:role/AWSLambdaTutorialRole
