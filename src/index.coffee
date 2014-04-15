module.exports = class FactoryB

  constructor: (data = {})->
    @data = {}
    for key, value of data
      @set(key, value)
    @data.default = {} unless @data.default?

  mutate = (data = {}, mutator)->
    for key, value of mutator
      if typeof value is 'string' or typeof value is 'number' \
      or typeof value is 'boolean' or value is null
        data[key] = value
      else if value instanceof Date
        data[key] = new Date value
      else
        data[key] = mutate(data[key], value)
    return data

  # Cloning derived from:
  # https://stackoverflow.com/questions/728360/most-elegant-way-to-clone-a-javascript-object
  cloneDate = (date)->
    new Date date.getTime()

  cloneArray = (array)->
    clone value for value of array

  cloneObject = (object)->
    copy = {}
    for key, value of object when object.hasOwnProperty(key)
      copy[key] = clone(value)
    return copy

  clone = (obj = {})->
    return obj if null == obj || "object" != typeof obj
    return cloneDate obj if obj instanceof Date
    return cloneArray obj if obj instanceof Array
    return cloneObject obj if obj instanceof Object
    throw new Error "Unable to copy object! Its type isn't supported."

  set: (key = 'default', data)->
    if key instanceof Object and key instanceof String isnt true
      data = clone key
      key = 'default'

  get: (key = 'default', mutator = {})->
    if typeof key isnt 'string'
      mutator = key
      key = 'default'
    return mutate(clone(@data[key]), mutator)

  keys: ()-> data.keys()