exports.handler = async (event) => {
    console.log("Received event:", event);

    return {
        statusCode: 200,
        body: JSON.stringify({
            message: "Hello from AWS Lambda!",
            event: event
        })
    };
};
