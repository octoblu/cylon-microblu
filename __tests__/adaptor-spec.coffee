jest.autoMockOff()
meshblu = require 'meshblu'
Adapter = require '../lib/adaptor'
describe 'Adaptor', ->
  beforeEach ->
    @sut = new Adapter()
  it 'should exist', ->
    expect(@sut).not.toBeUndefined()

  describe 'when constructed with a uuid and token', ->
    beforeEach ->
      @sut = new Adapter uuid: 'U1', token: 'T1'

    describe 'when connect is called', ->

      beforeEach () ->
        @sut.connect()
        meshblu.__connection.emit 'ready', 'blah'

      it 'should call meshblu.createConnection with the provided credentials', ->
        expect(meshblu.createConnection).lastCalledWith
          uuid: 'U1'
          token: 'T1'
          port: 443
          server: 'meshblu.octoblu.com'

    describe 'when constructed with a uuid, token, server, port, and other stuff', ->
      beforeEach ->
        @sut = new Adapter
          uuid: 'U2'
          token: 'T2'
          server: 'whatevs'
          port: 80085
          color: 'orange'
          ice_cream: 'please'

      describe 'when connect is called and ready is emitted', ->

        beforeEach ->
          @callback = jest.genMockFunction()
          @sut.connect @callback
          meshblu.__connection.emit 'ready'

        it 'should call meshblu.createConnection with the provided credentials', ->
          expect(meshblu.createConnection).lastCalledWith
            uuid: 'U2'
            token: 'T2'
            server: 'whatevs'
            port: 80085

        it 'should call the callback', ->
          expect(@callback).toBeCalled()


      describe 'when connect is called and ready is not emitted', ->

        beforeEach ->
          @callback = jest.genMockFunction()
          @sut.connect @callback

        it 'should not call the callback', ->
          expect(@callback).not.toBeCalled()

      describe 'when digitalRead is called and the adaptor is not connected', ->
        beforeEach ->
          @callback = jest.genMockFunction()
          @sut.digitalRead 1, @callback

        it 'should throw an error explaining that the adaptor isn\'t connected', ->
          expect(@callback.mock.calls[0]?[0]).toEqual Error ('meshblu connection is not ready') unless meshbluConfig?

      describe 'when digitalRead is called and the adaptor is connected', ->
        beforeEach ->
          @callback = jest.genMockFunction()
          @sut.connect()
          @sut.digitalRead 1, @callback

        it 'should message the meshblu connection with a topic of "digitalRead" and a pin of 1', ->
          expect(meshblu.__connection.message).toBeCalledWith(
            '*',
            topic: 'digitalRead'
            payload:
              pin: 1
          )

        it 'should not call the callback', ->
          expect(@callback).not.toBeCalled()

      describe 'when digitalRead is called and the connection emits data for that pin', ->
        beforeEach ->
          @callback = jest.genMockFunction()
          @sut.connect()
          @sut.digitalRead 7, @callback
          meshblu.__connection.emit 'message',
            topic: 'digitalRead'
            payload:
              pin: 7
              value: 4

        it 'should call the callback with the value from the connection', ->
          expect(@callback).toBeCalledWith null, 4


      describe 'when digitalRead is called and the connection emits data for that pin multiple times', ->
        beforeEach ->
          @callback = jest.genMockFunction()
          @sut.connect()
          @sut.digitalRead 1, @callback
          meshblu.__connection.emit 'message',
            topic: 'digitalRead'
            payload:
              pin: 1
              value: 7

          meshblu.__connection.emit 'message',
            topic: 'digitalRead'
            payload:
              pin: 1
              value: 9

        it 'should call the callback with the values from the connection', ->
          expect(@callback.mock.calls.length).toBe 2

      describe 'when digitalRead is called and the connection emits data for other pins', ->
        beforeEach ->
          @callback = jest.genMockFunction()
          @sut.connect()
          @sut.digitalRead 1, @callback
          meshblu.__connection.emit 'message',
            topic: 'digitalRead'
            payload:
              pin: 10
              value: 700

        it 'should call the callback with the value from the connection', ->
          expect(@callback.mock.calls.length).toBe 0

    describe 'when constructed a uuid, token, and devices list', ->
      beforeEach ->
        @sut = new Adapter uuid: 'U1', token: 'T1', devices: ['T-800', 'T-600']

      describe 'when digitalRead is called', ->
        beforeEach ->
          @callback = jest.genMockFunction()
          @sut.connect()
          @sut.digitalRead 1, @callback

        it 'should message the meshblu connection with a topic of "digitalRead" and a pin of 1', ->
          expect(meshblu.__connection.message).toBeCalledWith(
            ['T-800', 'T-600'],
            topic: 'digitalRead'
            payload:
              pin: 1
          )

        it 'should not call the callback', ->
          expect(@callback).not.toBeCalled()
