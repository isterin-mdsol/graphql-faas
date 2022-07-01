'use strict'
import fs from 'fs'

let db = JSON.parse(fs.readFileSync('database.json'));

module.exports = async ({body: {args, ctx, info, headers}}, context) => {
  console.log("ARGUMENTS FOR 'clients'", args, ctx, info, headers, ctx)
  let data = db.clients
  if (args && args.id) {
    data = db.clients.find(entity => entity.id === args.id);
  }
  const result = {
    'body': JSON.stringify(data || null),
    'content-type': "application/json"
  }

  return context
    .status(200)
    .succeed(result)
}
