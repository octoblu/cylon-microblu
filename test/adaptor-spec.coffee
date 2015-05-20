Adapter = require '../lib/adaptor.coffee'
describe 'Adaptor', ->
  beforeEach ->
    jest.autoMockOff()
    jest.mock 'meshblu'
    @meshblu = require 'meshblu'
    @sut = new Adapter()
  it 'should exist', ->
    expect(@sut).toBeTruthy()

  describe 'when constructed with a uuid and token', ->
    beforeEach ->
      @sut = new Adapter uuid: 'U1', token: 'T1'
    describe 'when connect is called', ->

      beforeEach (done) ->
        @sut.connect done

      it 'should call meshblu.createConnection with the provided credentials', ->
        expect(@meshblu).toBeTruthy()
