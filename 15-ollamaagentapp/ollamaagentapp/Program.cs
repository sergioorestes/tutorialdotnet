using OllamaSharp;
using OllamaSharp.Models.Chat;

namespace OllamaAgentApp
{
    public class Program
    {
        public static async Task Main()
        {
            var ollamaApiClient =
                new OllamaApiClient(
                    new Uri("http://localhost:11434"), "mistral_7b_portuguese-unsloth:latest"
                );

            // Start the conversation with context for the AI model
            List<Message> chatHistory = new();

            while (true)
            {
                // Get user prompt and add to chat history
                Console.WriteLine("Your prompt:");
                var userPrompt = Console.ReadLine();
                chatHistory.Add(new Message(ChatRole.User, userPrompt!));

                // Stream the AI response and add to chat history
                Console.WriteLine("AI Response:");
                var response = string.Empty;

                var request =
                    new ChatRequest
                    {
                        Model = "bert_tiny_embeddings_english_portuguese-unsloth:latest",
                        Messages = chatHistory,
                        Stream = false
                    };

                await foreach (var responseStream in ollamaApiClient.Chat(request))
                {
                    // Process each chunk of the response as it arrives
                    if (responseStream?.Message?.Content != null)
                    {
                        Console.Write(responseStream.Message.Content); // Print content as it streams
                        response += responseStream.Message.Content;
                    }
                }

                chatHistory.Add(new Message(ChatRole.Assistant, response));
                Console.WriteLine();
            }
        }
    }
}