using Xunit;
using Amazon.Lambda.TestUtilities;

namespace awslambdaapp.Tests;

public class FunctionTest
{
    [Fact]
    public void TestToUpperFunction()
    {
        // Invoke the lambda function and confirm the string was upper cased.
        var function = new Function();
        var context = new TestLambdaContext();

        var upperCase = function.FunctionHandler("hello world", context);

        Assert.Equal("HELLO WORLD", upperCase);
    }

    [Theory]
    [InlineData("hello world")]
    [InlineData("Hello World")]
    public void FunctionHandler(string param)
    {
        var function = new Function();
        var context = new TestLambdaContext();

        var upperCase = function.FunctionHandler(param, context);

        Assert.Equal("HELLO WORLD", upperCase);
    }
}
