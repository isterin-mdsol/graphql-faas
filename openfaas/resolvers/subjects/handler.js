'use strict'
const fs = require('fs')

let db = JSON.parse(fs.readFileSync(`${__dirname}/common/database.json`));

module.exports = async ({body: {parent, args, ctx, info, headers}}, context) => {
  console.log("ARGUMENTS FOR 'subjects'", args, ctx, info, headers, ctx)
  
  let data = null
  if (parent && parent.id) {
    data = db.studySubjects[parent.id]
  }
  
  return context
    .status(200)
    .headers({"content-type": "application/json"})
    .succeed(JSON.stringify(data || null),)
}
