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
