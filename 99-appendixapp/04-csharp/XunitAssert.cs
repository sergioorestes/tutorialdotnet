
[Fact]
public void ExceptionRecord()
{
    Action act = () =>
    {
        throw new InvalidOperationException();
    };

    var ex = Record.Exception(act);

    Assert.IsType<InvalidOperationException>(ex);
}

[Fact]
public void ExceptionThrows()
{
    Action act = () =>
    {
        throw new InvalidOperationException();
    };

    var ex = Assert.Throws<InvalidOperationException>(act);

    Assert.NotNull(ex);
}

private class AssertEx
{
    public static Exception? NoThrows<T>(Action act)
        where T: Exception
    {
        try
        {
            act.Invoke();
        }
        catch (Exception ex)
        {
            Assert.IsNotType<T>(ex);

            return ex;
        }

        return default;
    }
}

[Fact]
public void ExceptionNoThrows()
{
    Action act = () =>
    {
        throw new AmazonS3Exception(default(string));
    };

    var ex = AssertEx.NoThrows<AmazonS3Exception>(act);

    Assert.Null(ex);
}
