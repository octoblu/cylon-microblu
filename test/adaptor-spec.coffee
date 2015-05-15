jest.autoMockOff()
describe 'Adaptor', ->
  beforeEach ->
    @sut = require '../lib/adaptor.coffee'
  it 'should exist', ->
    expect(@sut).toBeTruthy()
