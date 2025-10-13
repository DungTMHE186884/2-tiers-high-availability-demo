
const express = require('express');
const os = require('os');

const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send(`Hello from ${os.hostname()}!`);
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
