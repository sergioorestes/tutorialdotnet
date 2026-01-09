using Xunit;
using Amazon.Lambda.TestUtilities;
using Amazon.Lambda.S3Events;

using System.Net;
using System.Diagnostics;

using Amazon;
using Amazon.Runtime;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Util;

namespace awslambdas3app.Tests;

public class FunctionTest
{
    IAmazonS3 s3Client;

    string bucketName = "tutorial-04-awslambdas3app";
    string objectName = "text.txt";

    public FunctionTest()
    {
        AWSCredentials awsCredentials = new BasicAWSCredentials("<access_key>", "<secret_key>");

        this.s3Client = new AmazonS3Client(awsCredentials, RegionEndpoint.USWest2);
    }

#region S3 Method(s)

    private string GetFolderPath()
    {
        return Directory.GetParent(
                AppDomain.CurrentDomain.BaseDirectory
            )!.Parent!.Parent!.Parent!.FullName;
    }

    [Fact]
    public async Task PutObjectAsync()
    {
        string folderPath = GetFolderPath();

        var request = new PutObjectRequest
        {
            BucketName  = bucketName,
            Key         = objectName,
            FilePath    = $"{folderPath}/files/in/{objectName}"
        };

        var response = await s3Client.PutObjectAsync(request);

        Assert.True(response.HttpStatusCode == HttpStatusCode.OK);
    }

    [Fact]
    public async Task GetObjectAsync()
    {
        string folderPath = GetFolderPath();

        var request = new GetObjectRequest
        {
            BucketName  = bucketName,
            Key         = objectName
        };

        GetObjectResponse response = await s3Client.GetObjectAsync(request);

        Assert.True(response.HttpStatusCode == HttpStatusCode.OK);

        try
        {
            await response.WriteResponseStreamToFileAsync(
                    $"{folderPath}/files/out/{objectName}", true, CancellationToken.None
            );
        }
        catch(AmazonS3Exception ex)
        {
            Assert.Fail(ex.Message);
        }
    }

    [Fact]
    public async Task PutObjectMetadataAsync()
    {
        var request = new PutObjectRequest
        {
            BucketName  = bucketName,
            Key         = objectName,
            ContentType = "text/plain"
        };

        request.Metadata.Add("x-amz-meta-title", "title");

        var response = await s3Client.PutObjectAsync(request);

        Assert.True(response.HttpStatusCode == HttpStatusCode.OK);
    }

    [Fact]
    public async Task GetObjectMetadataAsync()
    {
        var request = new GetObjectMetadataRequest
        {
            BucketName  = bucketName,
            Key         = objectName
        };

        var response = await s3Client.GetObjectMetadataAsync(request);

        Assert.True(response.HttpStatusCode == HttpStatusCode.OK);

        ICollection<string> metaKeys = response.Metadata.Keys;

        foreach (var key in metaKeys)
        {
            Debug.WriteLine($"{key}: {response.Metadata[key]}");
        }
    }

    [Fact]
    public async Task ListObjectsV2Async()
    {
        try
        {
            var request = new ListObjectsV2Request
            {
                BucketName  = bucketName,
                MaxKeys     = 5
            };

            ListObjectsV2Response response;

            do
            {
                response = await s3Client.ListObjectsV2Async(request);

                response.S3Objects
                    .ForEach(obj => Debug.WriteLine($"{obj.Key,-35}{obj.LastModified.ToShortDateString(),10}{obj.Size,10}"));

                request.ContinuationToken = response.NextContinuationToken;
            }
            while (response.IsTruncated);
        }
        catch (AmazonS3Exception ex)
        {
            Debug.WriteLine($"Error encountered on server. Message:'{ex.Message}' getting list of objects.");

            Assert.Fail(ex.Message);
        }

    }

#endregion

    [Fact]
    public async Task TestS3EventLambdaFunction()
    {
        var bucketName = this.bucketName;
        var key        = this.objectName;

        try
        {
            // Create a bucket an object to setup a test data.
            await s3Client.PutBucketAsync(bucketName);
        }
        catch (AmazonS3Exception ex)
        {
            Debug.WriteLine($"Error encountered on server. Message:'{ex.Message}'.");
        }

        try
        {
            await s3Client.PutObjectAsync(new PutObjectRequest
            {
                BucketName  = bucketName,
                Key         = key,
                ContentBody = "ContentBody"
            });

            // Setup the S3 event object that S3 notifications would create with the fields used by the Lambda function.
            var s3Event = new S3Event
            {
                Records = new List<S3Event.S3EventNotificationRecord>
                {
                    new S3Event.S3EventNotificationRecord
                    {
                        S3 = new S3Event.S3Entity
                        {
                            Bucket = new S3Event.S3BucketEntity {Name = bucketName },
                            Object = new S3Event.S3ObjectEntity {Key = key }
                        }
                    }
                }
            };

            // Invoke the lambda function and confirm the content type was returned.
            var function = new Function(s3Client);
            var contentType = await function.FunctionHandler(s3Event, new TestLambdaContext());

            Assert.Equal("text/plain", contentType);
        }
        finally
        {
            try
            {
            // Clean up the test data
                await AmazonS3Util.DeleteS3BucketWithObjectsAsync(s3Client, bucketName);
            }
            catch (AmazonS3Exception ex)
            {
                Debug.WriteLine($"Error encountered on server. Message:'{ex.Message}'.");
            }
        }
    }
}