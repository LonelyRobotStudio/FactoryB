module.exports = class FactoryB

  constructor: (data = {})->
    @data = {}
    for key, value of data
      @set(key, value)
    @data.default = {} unless @data.default?

  mutate = (data = {}, mutator)->
    for key, value of mutator
      if typeof value is 'string' or typeof value is 'number' \
      or typeof value is'boolean' or value is null
        data[key] = value
      else
        data[key] = mutate(data[key], value)
    return data

  clone = (data = {})->
    JSON.parse JSON.stringify(data)

  set: (key, data)->
    if typeof key isnt 'string' and typeof key is 'object' and key isnt null
      data = clone(key)
      key = 'default'
    @data[key] = clone(data) if data isnt null

  get: (key = 'default', mutator = {})->
    if typeof key isnt 'string'
      mutator = key
      key = 'default'
    return mutate(clone(@data[key]), mutator)

  keys: ()-> data.keys()