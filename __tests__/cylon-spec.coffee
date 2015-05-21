jest.autoMockOff()

path = require 'path'
Cylon = require 'cylon'
describe 'Cylon', ->
  it 'should exist', ->
    expect(Cylon).toBeDefined()

  describe 'when the microblu-cylon adapter is registered properly', ->
    beforeEach ->
      microbluPath = path.join process.cwd(), '/lib/microblu-cylon'

      Registry = require 'cylon/lib/registry'
      Registry.register microbluPath
      @module = Registry.findByModule 'microblu'
    it 'should register the adapter', ->
      expect(@module).toBeDefined()

    describe 'when a robot is constructed using microblu-cylon', ->
      beforeEach ->
        @microbot = Cylon.robot
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

      it 'should exist', ->
        expect(@microbot).toBeDefined()

#
# microbot = Cylon.robot
#   name: 'Microbot'
#   connections:
#     microblu:
#       adaptor: 'microblu'
#   devices:
#     led:
#       driver: 'led', pin: 13
#   work: (bot) ->
#     every (1).second(), ->
#       bot.led.toggle()
#
# microbot.start()
