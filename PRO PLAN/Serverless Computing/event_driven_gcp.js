const functions = require('@google-cloud/functions-framework');
const { Firestore } = require('@google-cloud/firestore');

const firestore = new Firestore();

functions.cloudEvent('processUpload', async cloudEvent => {
    const data = cloudEvent.data;

    const bucket = data.bucket;
    const objectName = data.name;
    const size = Number(data.size || 0);

    console.log(`Processing: gs://${bucket}/${objectName}`);

    const documentId = `${bucket}/${objectName}`;

    await firestore
        .collection('fileMetadata')
        .doc(documentId)
        .set({
            fileName: objectName.split('/').pop(),
            bucket: bucket,
            objectName: objectName,
            size: size,
            uploadedAt: new Date().toISOString()
        });

    console.log('Metadata stored successfully');
});




// package.json
{
  "name": "gcp-file-workflow",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0",
    "@google-cloud/firestore": "^7.0.0"
  }
}
