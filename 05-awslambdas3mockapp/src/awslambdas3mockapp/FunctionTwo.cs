using Amazon.Lambda.Core;
using Amazon.Lambda.S3Events;
using Amazon.S3;

namespace awslambdas3mockapp;

public class FunctionTwo
{
    IAmazonS3 S3Client { get; set; }

    public FunctionTwo()
    {
        S3Client = new AmazonS3Client();
    }

    public FunctionTwo(IAmazonS3 s3Client)
    {
        this.S3Client = s3Client;
    }

    public async Task<string> FunctionHandler(S3Event evnt, ILambdaContext context)
    {
        var eventRecords = evnt.Records ?? new List<S3Event.S3EventNotificationRecord>();
        foreach (var record in eventRecords)
        {
            var s3Event = record.S3;
            if (s3Event == null)
            {
                continue;
            }

            try
            {
                var response = await this.S3Client.GetObjectMetadataAsync(s3Event.Bucket.Name, s3Event.Object.Key);
                return response.Headers.ContentType;
            }
            catch (Exception e)
            {
                context.Logger.LogError($"Error getting object {s3Event.Object.Key} from bucket {s3Event.Bucket.Name}. Make sure they exist and your bucket is in the same region as this function.");
                context.Logger.LogError(e.Message);
                context.Logger.LogError(e.StackTrace);
            }
        }
        return "No content type found.";
    }
}