const express = require("express");
const client = require("prom-client");

const app = express();
const port = 3000;

// Collect default Node.js metrics
client.collectDefaultMetrics();

// Custom HTTP request counter
const httpRequests = new client.Counter({
  name: "http_requests_total",
  help: "Total number of HTTP requests",
  labelNames: ["method", "route", "status_code"]
});

// HTTP request duration histogram
const httpDuration = new client.Histogram({
  name: "http_request_duration_seconds",
  help: "HTTP request duration in seconds",
  labelNames: ["method", "route", "status_code"]
});

// Middleware for metrics
app.use((req, res, next) => {
  const end = httpDuration.startTimer();

  res.on("finish", () => {
    httpRequests.inc({
      method: req.method,
      route: req.route?.path || req.path,
      status_code: res.statusCode
    });

    end({
      method: req.method,
      route: req.route?.path || req.path,
      status_code: res.statusCode
    });
  });

  next();
});

app.get("/", (req, res) => {
  res.send("Node.js application is running");
});

app.get("/api/users", (req, res) => {
  res.json([
    { id: 1, name: "Alice" },
    { id: 2, name: "Bob" }
  ]);
});

app.get("/api/orders", (req, res) => {
  res.json({
    orders: 5
  });
});

// Prometheus metrics endpoint
app.get("/metrics", async (req, res) => {
  res.set("Content-Type", client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(port, () => {
  console.log(`App running on port ${port}`);
});
