path = require 'path'
Cylon = require 'cylon'
microbluPath = path.join process.cwd(), 'lib/microblu-cylon'
console.log microbluPath
Registry = require 'cylon/lib/registry'
Registry.register microbluPath
console.log(Registry.search 'adaptor', 'microblu')

microbot = Cylon.robot
  name: 'Microbot'
  connections:
    microblu:
      adaptor: 'microblu'
  # devices:
  #   led:
  #     driver: 'led', pin: 13
  work: (bot) ->
    console.log 'hi'


microbot.start()
