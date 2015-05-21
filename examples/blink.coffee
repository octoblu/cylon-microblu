path = require 'path'
Cylon = require 'cylon'

#this stuff lets cylon find modules outside of the local node_modules
microbluPath = path.join process.cwd(), 'lib/microblu-cylon'
gpioPath = path.join process.cwd(), 'node_modules/cylon-gpio'
Registry = require 'cylon/lib/registry'
Registry.register microbluPath
Registry.register gpioPath

microbot = Cylon.robot
  name: 'Microbot'
  connections:
    microblu:
      adaptor: 'microblu'
  devices:
    led:
      driver: 'led', pin: 13
  work: (bot) ->
    every (1).second(), ->
      bot.led.toggle()

microbot.start()
