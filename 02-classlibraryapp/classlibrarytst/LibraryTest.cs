using System.Diagnostics;
using HelloWorld;

namespace classlibrarytst;

[TestClass]
public class LibraryTest
{
    private readonly Library library;

    public LibraryTest()
    {
        Debug.WriteLine("Constructor");

        library = new Library();
    }

    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine("Initialize");
    }

    [TestCleanup]
    public void TestCleanup()
    {
        Debug.WriteLine("Cleanup");
    }

    [TestMethod]
    [DataRow(true)]
    public void IsLibrary(bool param)
    {
        Debug.WriteLine("Execution");

        bool isLibrary = library.IsLibrary(param);

        Assert.IsTrue(isLibrary);
    }
}