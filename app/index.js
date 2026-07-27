const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const MESSAGE = process.env.WELCOME_MESSAGE || "Hello from Kubernetes!";

app.get('/', (req, res) => {
  res.json({
    status: "success",
    message: MESSAGE,
    timestamp: new Date()
  });
});

app.get('/health', (req, res) => {
  res.json({ status: "healthy" });
});

app.listen(PORT, () => {
  console.log(`Application is running on port ${PORT}`);
});
