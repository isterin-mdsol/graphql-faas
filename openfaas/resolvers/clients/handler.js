'use strict'

const clients = [
  {id: '1', name: 'Client 1'},
  {id: '2', name: 'Client 2'},
];

module.exports = async (event, context) => {
  let data = clients
  if (id) {
    data = clients[id]
  }
  const result = {
    'body': JSON.stringify(data),
    'content-type': event.headers["content-type"]
  }

  return context
    .status(200)
    .succeed(result)
}
