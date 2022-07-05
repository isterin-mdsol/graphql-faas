'use strict'
const fs = require('fs')

let db = JSON.parse(fs.readFileSync(`${__dirname}/common/database.json`));

module.exports = async ({body: {args, ctx, info, headers}}, context) => {
  console.log("ARGUMENTS FOR 'clients'", args, ctx, info, headers, ctx)
  let data = db.clients
  if (args && args.id) {
    data = db.clients.find(entity => entity.id === args.id);
  }
  
  return context
    .status(200)
    .headers({"content-type": "application/json"})
    .succeed(JSON.stringify(data || null),)
}
