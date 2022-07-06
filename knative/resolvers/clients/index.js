const express = require('express');
const fs = require('fs')

const app = express();

let db = JSON.parse(fs.readFileSync(`${__dirname}/database.json`));

app.post('/', (req, res) => {
  console.log('clients REQ', req);
  let { args } = req.body
  let data = db.clients
  if (args && args.id) {
    data = db.clients.find(entity => entity.id === args.id);
  }
  
  res.json(data)
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('clients listening on port', port);
});
