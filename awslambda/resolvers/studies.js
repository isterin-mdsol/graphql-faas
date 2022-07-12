'use strict'
const fs = require('fs')

let db = JSON.parse(fs.readFileSync(`${__dirname}/database.json`));

exports.handler = async event => {
  console.log("EVENT", event)
  let {parent} = JSON.parse(event.body)
  
  let data = db.clientStudies
  if (parent && parent.id) {
    data = db.clientStudies[parent.id];
  }

  return {
    statusCode: 200,
    headers: {"content-type": "application/json"},
    body: JSON.stringify(data || null),
  };
};