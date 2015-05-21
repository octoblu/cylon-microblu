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
    led:
      driver: 'led', pin: 13
  work: (bot) ->
    every (1).second(), ->
      bot.led.toggle()

microbot.start()
