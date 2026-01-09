using Xunit;
using System.Diagnostics;
using System.Net;
using System.Text.Json;
using Amazon;
using Amazon.Lambda;
using Amazon.Lambda.Model;
using Amazon.Runtime;
using Amazon.Lambda.TestUtilities;

namespace awslambdaapp.Tests;

public class FunctionTwoTest
{
    AmazonLambdaClient lambdaClient;

    public FunctionTwoTest()
    {
        AWSCredentials awsCredentials = new BasicAWSCredentials("<access_key>", "<secret_key>");

        AmazonLambdaConfig lambdaConfig = new AmazonLambdaConfig();
        lambdaConfig.ServiceURL     = "https://lambda.us-west-2.amazonaws.com";
        lambdaConfig.RegionEndpoint = RegionEndpoint.USWest2;

        lambdaClient = new AmazonLambdaClient(awsCredentials, lambdaConfig);
    }

    [Theory]
    [InlineData("{\"key\": \"hello world\"}")]
    public void FunctionHandler(string param)
    {
        var function = new FunctionTwo();
        var context = new TestLambdaContext();

        var upperCase = function.FunctionHandler(param, context);

        Assert.Equal("HELLO WORLD", upperCase);
    }

    [Theory]
    [InlineData("{\"key\": \"hello world\"}")]
    public async Task InvokeAsync(object param)
    {
        string payloadRequest = JsonSerializer.Serialize(param);

        var request =
            new InvokeRequest
            {
                FunctionName   = typeof(FunctionTwo).Name,
                Payload        = payloadRequest,
                InvocationType = InvocationType.RequestResponse
            };

        InvokeResponse response = await lambdaClient.InvokeAsync(request);

        int statusCode = response.StatusCode;

        Assert.Equal((int)HttpStatusCode.OK, statusCode);

        MemoryStream payload = response.Payload;

        var upperCase = JsonSerializer.Deserialize<string>(payload.ToArray());

        Assert.Equal("HELLO WORLD", upperCase);

        Debug.WriteLine(upperCase);
    }
}
