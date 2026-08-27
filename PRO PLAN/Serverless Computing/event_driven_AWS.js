import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const dynamodb = DynamoDBDocumentClient.from(client);

export const handler = async (event) => {
    console.log("Received S3 event:", JSON.stringify(event));

    for (const record of event.Records) {
        const bucket = record.s3.bucket.name;
        const objectKey = decodeURIComponent(
            record.s3.object.key.replace(/\+/g, " ")
        );

        const size = record.s3.object.size;

        await dynamodb.send(
            new PutCommand({
                TableName: "FileMetadata",
                Item: {
                    fileId: objectKey,
                    fileName: objectKey.split("/").pop(),
                    bucket: bucket,
                    objectKey: objectKey,
                    size: size,
                    uploadedAt: new Date().toISOString()
                }
            })
        );
    }

    return {
        statusCode: 200,
        body: "File metadata stored successfully"
    };
};
