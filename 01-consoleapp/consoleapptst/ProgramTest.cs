
using System.Net.WebSockets;

namespace consoleapptst
{
    [TestClass]
    public class ProgramTest
    {
        private const string Expected = "Hello World!";

        [TestMethod]
        public void MainTest()
        {
            using (var sw = new StringWriter())
            {
                Console.SetOut(sw);

                HelloWorld.Program.Main();

                var result = sw.ToString().Trim();

                Assert.AreEqual(Expected, result);
            }
        }
    }
}