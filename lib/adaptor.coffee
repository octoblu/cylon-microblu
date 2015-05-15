Cylon = require 'cylon'
debug = require('debug')('cylon-microblu')

MIN_PULSE_WIDTH = 600
MAX_PULSE_WIDTH = 2500
MAX_PERIOD = 7968


class MicrobluAdaptor extends Cylon.Adaptor
  constructor: (opts={}) ->
    super opts
    @pins = []
    @pwmPins = []
    @analogPins = []
    @interval = opts.interval || 0.01
    @i2c = null
    @events = [
      'digitalRead'
      'analogRead'
    ]

  connect: (callback) =>
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

digitalRead: (pin, callback) =>
  debug 'digitalRead', arguments

digitalWrite: (pin, value) =>
  debug 'digitalRead', arguments

analogRead: (pin, callback) =>
  debug 'analogRead', arguments

servoWrite: (pin, value) =>
  debug 'servoWrite', arguments

pwmWrite: (pinNum, value, servo) =>
  debug 'pwmWrite', arguments

i2cWrite: (address, cmd, buff, callback) =>
  debug 'i2cWrite', arguments

i2cRead: (address, cmd, length, callback) =>
  debug 'i2cWrite', arguments
