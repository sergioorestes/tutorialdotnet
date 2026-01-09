using System.Text.Json;
using Amazon.Lambda.Core;
using Amazon.Lambda.Serialization.SystemTextJson;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
//[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace awslambdaapp;

public class FunctionTwo
{
    public class NestedClass
    {
        public string Key { get; set; } = string.Empty;
    }

    [method: LambdaSerializer(typeof(DefaultLambdaJsonSerializer))]
    public object? FunctionHandler(object input, ILambdaContext context)
    {
        string jsonString = input.ToString() ?? string.Empty;

        context.Logger.LogLine(jsonString);

        var options = new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        };

        NestedClass? nestedClass = JsonSerializer.Deserialize<NestedClass>(jsonString, options);

        context.Logger.LogLine($"key: {nestedClass?.Key}");

        return nestedClass?.Key.ToUpper();

    }
}
