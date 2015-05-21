jest.autoMockOff()

path = require 'path'
describe 'Cylon', ->
  beforeEach ->
    @Cylon = require 'cylon'
  it 'should exist', ->
    expect(@Cylon).toBeDefined()

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
        @microbot = @Cylon.robot
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

      describe 'when the robot is started, meshblu is ready, and 2 ticks have gone by', ->
        beforeEach ->
          @microbot.start()
          @microbot.microblu.meshbluConn.emit 'ready'
          jest.runOnlyPendingTimers()
          jest.runOnlyPendingTimers()
          @messageMock = @microbot.microblu.meshbluConn.message.mock

        it 'should have sent 2 messages', ->
          expect(@messageMock.calls.length).toBe 2

        it 'should have turned the led on at first', ->
          expect(@messageMock.calls[0][1]).toEqual
             topic: 'digitalWrite'
             payload:
               pin: 13
               value: 1

        it 'should have then turned the led off', ->
          expect(@messageMock.calls[1][1]).toEqual
            topic: 'digitalWrite'
            payload:
              value: 0
              pin: 13


#
# microbot = @Cylon.robot
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
