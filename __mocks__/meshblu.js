var EventEmitter = require('events').EventEmitter;
connection = new EventEmitter();
connection.message = jest.genMockFunction();

var Meshblu = {
  __connection: connection,
  createConnection: jest.genMockFunction()
    .mockImplementation(function(opts) {
      return this.__connection;
    })
  };

module.exports = Meshblu;
