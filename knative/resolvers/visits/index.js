const express = require('express');
const fs = require('fs')

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

let db = JSON.parse(fs.readFileSync(`${__dirname}/database.json`));

app.post('/', (req, res) => {
  // console.log('clients REQ', req);
  console.log("BODY: ", req.body)
  let { args, parent } = req.body
  
  let data = null
  if (parent && parent.id) {
    data = db.subjectVisits[parent.id]
  }

  res.json(data)
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('clients listening on port', port);
});
