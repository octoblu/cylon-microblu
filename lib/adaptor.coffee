Cylon = require 'cylon'
meshblu = require 'meshblu'
_ = require 'lodash'
debug = require('debug')('microblu:cylon')
MIN_PULSE_WIDTH = 600
MAX_PULSE_WIDTH = 2500
MAX_PERIOD = 7968
meshbluDefaults =
  server: 'meshblu.octoblu.com'
  port: 443

meshbluProperties = ['server', 'port', 'uuid', 'token']
notReadyError = new Error 'meshblu connection is not ready'

class MicrobluAdaptor extends Cylon.Adaptor
  constructor: (opts={}) ->
    super opts
    @pins = []
    @pwmPins = []
    @analogPins = []
    @interval = opts.interval || 0.01
    @i2c = null
    @devices = opts.devices || '*'
    @events = [
      'digitalRead'
      'analogRead'
    ]

    @meshbluConfig = _.pick _.defaults(opts, meshbluDefaults), meshbluProperties

  connect: (callback=->) =>
    callback = _.once callback
    @meshbluConn = meshblu.createConnection @meshbluConfig
    @meshbluConn.on 'ready', =>
      callback()


  disconnect: (callback) =>
    callback()

  commands : [
    'digitalRead'
    'digitalWrite'
    'pwmWrite'
    'servoWrite'
    'analogRead'
    'servoWrite'
    'firmwareName'
    'i2cWrite'
    'i2cRead'
  ]

  firmwareName: =>
    "microblu v1"

  digitalRead: (pin, callback=->) =>
    return unless @assertConnected(callback) == true
    @meshbluConn.message(
      @devices,
      topic: 'digitalRead'
      payload:
        pin: pin
    )

    @subscribeOnce 'digitalRead', pin, callback

  digitalWrite: (pin, value) =>
    throw notReadyError unless @assertConnected()
    @meshbluConn.message(
      @devices,
      topic: 'digitalWrite'
      payload:
        pin: pin
        value: value
    )

  analogRead: (pin, callback=->) =>
    return unless @assertConnected(callback) == true
    @meshbluConn.message(
      @devices,
      topic: 'analogRead'
      payload:
        pin: pin
    )

    @subscribeOnce 'analogRead', pin, callback

  servoWrite: (pin, value) =>
    throw notReadyError unless @assertConnected()
    @meshbluConn.message(
      @devices,
      topic: 'servoWrite'
      payload:
        pin: pin
        value: value
    )

  pwmWrite: (pin, value, servo) =>
    throw notReadyError unless @assertConnected()
    debug "I can't use this...yet"

  i2cWrite: (address, cmd, buff, callback=->) =>
    return unless @assertConnected(callback) == true
    debug "I can't use this...yet"

  i2cRead: (address, cmd, length, callback=->) =>
    return unless @assertConnected(callback) == true
    debug "I can't use this...yet"

  assertConnected: (callback=->) =>
    if !@meshbluConn?
      callback notReadyError
      return notReadyError

    true

  subscribeOnce: ( topic, pin, callback=-> ) =>
    pinCallback = (msg) =>
      return unless msg.topic == topic
      return unless msg.payload.pin == pin
      @meshbluConn.removeListener 'message', pinCallback
      callback null, msg.payload.value

    @meshbluConn.on 'message', pinCallback


module.exports = MicrobluAdaptor
