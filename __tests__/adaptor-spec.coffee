jest.dontMock '../lib/adaptor'

describe 'Adaptor', ->
  beforeEach ->
    @Adapter = require '../lib/adaptor'
    @sut = new @Adapter()
    @meshblu = require 'meshblu'
  it 'should exist', ->
    expect(@sut).not.toBeUndefined()

  describe 'when constructed with a uuid and token', ->
    beforeEach ->
      @sut = new @Adapter uuid: 'U1', token: 'T1'

    describe 'when connect is called', ->

      beforeEach (done) ->
        @sut.connect done

      it 'should call meshblu.createConnection with the provided credentials', ->
        expect(@meshblu.createConnection.mock.calls[0][0]).toEqual
          uuid: 'U1'
          token: 'T1'
          port: 443
          server: 'meshblu.octoblu.com'

    describe 'when constructed with a uuid, token, server, port, and other stuff', ->
      beforeEach ->
        @sut = new @Adapter
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

        it 'should call meshblu.createConnection with the provided credentials', ->
          expect(@meshblu.createConnection.mock.calls[0][0]).toEqual
            uuid: 'U2'
            token: 'T2'
            server: 'whatevs'
            port: 80085
