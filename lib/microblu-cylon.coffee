Adaptor = require './adaptor'

module.exports =
  adaptors: ['microblu']
  dependencies: ["cylon-gpio", "cylon-i2c"]
  adaptor: (opts) ->
    new Adaptor opts
