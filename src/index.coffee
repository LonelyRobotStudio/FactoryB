module.exports = class FactoryB

  @_factories = {}

  @set = (name, factory)-> @_factories[name] = factory
  @get = (name)-> @_factories[name]
  @keys = -> @_factories.keys()

  constructor: (name, data)->
    data ?= name
    FactoryB.set name, this if typeof name is 'string'
    @data = default: {}
    @set key, value for key, value of data

  _mutate = (data, mutator)->
    for key, value of mutator
      if value is null or typeof value isnt 'object' or value instanceof Date \
      or value instanceof Array
        if value instanceof Function
          data[key] = value(data?[key])
        else data[key] = value
      else data[key] = _mutate(data[key], value)
    return data

  # Cloning derived from:
  # https://stackoverflow.com/questions/728360/most-elegant-way-to-clone-a-javascript-object
  _cloneDate = (date)-> new Date date.getTime()

  _cloneArray = (array)-> _clone value for value in array

  _cloneObject = (object)->
    copy = {}
    for key, value of object when object.hasOwnProperty(key)
      copy[key] = _clone(value)
    return copy

  _clone = (obj)->
    return obj if obj is null or typeof obj isnt 'object'
    return _cloneDate obj if obj instanceof Date
    return _cloneArray obj if obj instanceof Array
    return _cloneObject obj if obj instanceof Object
    throw new Error "Unable to copy object! Its type isn't supported."

  set: (key = 'default', data)->
    if key instanceof Object and key instanceof String isnt true
      data = key
      key = 'default'
    @data[key] = _clone data if data isnt null

  get: (mutators...)->
    mutators.unshift 'default' unless typeof mutators[0] is 'string'
    mutators = (_clone @data[mutator] ? mutator for mutator in mutators)
    mutators.unshift {}
    mutators.reduce _mutate

  setModel: (@model)->
  setBuild: (@buildMethod)->
  build: (mutators...)->
    if @model?
      if @buildMethod?
        @buildMethod @get(mutators...), @model
      else
        new @model @get mutators

  keys: -> Object.keys(@data)
