jest.autoMockOff()
jest.dontMock '../lib/adaptor'
jest.dontMock 'lodash'
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
        meshblu.__emitter.emit 'ready', 'blah'

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

      describe 'when connect is called', ->

        beforeEach () ->
          @callback = jest.genMockFunction()
          @sut.connect @callback
          meshblu.__emitter.emit 'ready'

        it 'should call meshblu.createConnection with the provided credentials', ->
          expect(meshblu.createConnection).lastCalledWith
            uuid: 'U2'
            token: 'T2'
            server: 'whatevs'
            port: 80085

        it 'should call the callback', ->
          expect(@callback).toBeCalled()
