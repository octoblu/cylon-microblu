Adaptor = require './adaptor'

module.exports =
  adaptors: ["microblu-cylon"]
  adaptor: (opts) ->
    new Adaptor opts
