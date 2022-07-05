const express = require('express');
const app = express();

app.post('/', (req, res) => {
  console.log('clients REQ', req);

  res.json({
    "id": "1",
    "name": "Client 1"
  })
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('clients listening on port', port);
});
