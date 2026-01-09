using Amazon.Lambda.Core;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace awslambdaapp;

public class Function
{
    /// <summary>
    /// A simple function that takes a string and does a ToUpper
    /// </summary>
    /// <param name="input">The event for the Lambda function handler to process.</param>
    /// <param name="context">The ILambdaContext that provides methods for logging and describing the Lambda environment.</param>
    /// <returns></returns>
    public string FunctionHandler(string input, ILambdaContext context)
    {
        Console.WriteLine("Function name: " + context.FunctionName);
        Console.WriteLine("Max mem allocated: " + context.MemoryLimitInMB);
        Console.WriteLine("Time remaining: " + context.RemainingTime);
        Console.WriteLine("CloudWatch log stream name: " + context.LogStreamName);
        Console.WriteLine("CloudWatch log group name: " + context.LogGroupName);

        return input.ToUpper();
    }
}
