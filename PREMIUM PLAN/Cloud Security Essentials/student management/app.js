const {
  SecretsManagerClient,
  GetSecretValueCommand
} = require("@aws-sdk/client-secrets-manager");

const mysql = require("mysql2/promise");

const client = new SecretsManagerClient({
  region: "ap-south-1"
});

async function getDatabaseSecret() {
  const response = await client.send(
    new GetSecretValueCommand({
      SecretId: "student-app/database"
    })
  );

  return JSON.parse(response.SecretString);
}

async function main() {
  const secret = await getDatabaseSecret();

  const connection = await mysql.createConnection({
    host: secret.host,
    user: secret.username,
    password: secret.password,
    database: secret.database,
    port: secret.port
  });

  const [rows] = await connection.execute(
    "SELECT * FROM students"
  );

  console.table(rows);

  await connection.end();
}

main().catch(console.error);
