module.exports = async function (context, myBlob) {
    const fileName = context.bindingData.name;

    console.log(`Processing uploaded file: ${fileName}`);

    const metadata = {
        id: `uploads/${fileName}`,
        partitionKey: "uploads",
        fileName: fileName,
        container: "uploads",
        size: myBlob.length,
        uploadedAt: new Date().toISOString()
    };

    context.bindings.cosmosOutput = metadata;
    console.log("Metadata sent to Cosmos DB:", metadata);
};
