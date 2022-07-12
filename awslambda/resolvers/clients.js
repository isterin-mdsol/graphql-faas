'use strict'
const fs = require('fs')

let db = JSON.parse(fs.readFileSync(`${__dirname}/database.json`));

exports.handler = async event => {
  console.log("EVENT", event)
  let {args} = event.body
  console.log("ARGS", args)
  console.log("CLIENTS", db.clients)
  
  let data = db.clients
  if (args && args.id) {
    data = db.clients.find(entity => entity.id === args.id);
  }

  return {
    statusCode: 200,
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify(data || null),
  };
};