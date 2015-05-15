Adaptor = require './adaptor'

module.exports =
  adaptors: ['microblu']
  adaptor: (opts) ->
    new Adaptor opts
