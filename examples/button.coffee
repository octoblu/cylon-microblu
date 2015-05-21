path = require 'path'
Cylon = require 'cylon'
_ = require 'lodash'

meshbluJSON = require './meshblu.json'
microbluConfig = _.extend {}, meshbluJSON, adaptor: 'microblu'

#this stuff lets cylon find modules outside of the local node_modules
microbluPath = path.join process.cwd(), '../lib/microblu-cylon'
Registry = require 'cylon/lib/registry'
Registry.register microbluPath

microbot = Cylon.robot
  name: 'Microbot'
  connections:
    microblu:
      microbluConfig
  devices:
    button:
      driver: 'button'
      pin: 2
  work: (bot) ->
    bot.button.on 'push', ->
      console.log 'button pushed!'

microbot.start()
