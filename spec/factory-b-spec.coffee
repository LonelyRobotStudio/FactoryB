describe "Truth", ->
  it "should be true", ->
    expect(true).toBeTruthy()

describe 'Factory B', ->
  try
    FactoryB = require '../src'
  catch
    FactoryB = require '../app'

  describe 'has a constructor that', ->

    it 'should accept nothing', ->
      bee = new FactoryB
      expect(bee).not.toBeNull()

    it 'should accept a JSON object with sub-objects', ->
      bee = new FactoryB
        tree:
          frog: 'danny'
          squirrel: 'timmy'
        default:
          house: 'round'
          dog: 'square'
      expect(bee).not.toBeNull()

  describe 'has a get method that', ->

    it 'should accept nothing and return a JSON object held under the key
        \'default\'', ->
      json =
        frog: 'jump'
        bacon: 'delicious'
      bee = new FactoryB default: json
      expect(bee.get()).toEqual json

    it 'should accept a string as a key and return a JSON object held under that
        key', ->
      json =
        frog: 'jump'
        bacon: 'delicious'
      bee = new FactoryB json: json
      expect(bee.get('json')).toEqual json

    it 'should accept a string as a key and a JSON object as mutator and reuturn
        an altered JSON object', ->
      originalJson =
        ice: 'cold'
        fire: 'fire'
      json =
        ice: 'cold'
        fire: 'fire'
      expectedJson =
        ice: 'melted'
        fire: 'fire'
      mutator =
        ice: 'melted'

      bee = new FactoryB json: json
      result = bee.get('json', mutator)

      expect(result).not.toEqual originalJson
      expect(result).toEqual expectedJson

    it 'should accept a JSON object as a mutator and return the JSON object
        under the default key altered', ->
      originalJson =
        ice: 'cold'
        fire: 'fire'
      json =
        ice: 'cold'
        fire: 'fire'
      expectedJson =
        ice: 'melted'
        fire: 'fire'
      mutator =
        ice: 'melted'

      bee = new FactoryB default: json
      result = bee.get(mutator)

      expect(result).not.toEqual originalJson
      expect(result).toEqual expectedJson

    it 'should not alter the contents of a key when mutating objects', ->
      originalJson =
        ice: 'cold'
        fire: 'fire'
      json =
        ice: 'cold'
        fire: 'fire'
      expectedJson =
        ice: 'melted'
        fire: 'fire'
      mutator =
        ice: 'melted'

      bee = new FactoryB default: json
      result = bee.get(mutator)
      result2 = bee.get()

      expect(result).toEqual expectedJson
      expect(result2).toEqual originalJson

    it 'should accept multiple JSON objects and should return default after they
        are applied to it in order', ->
      json =
        pine: 'tree'
        ice: 'cold'
        fire: 'fire'
      ice =
        ice: 'COLD'
        fire: 'FIRE'
      fire =
        fire: 'HOT'
      iceFireJson =
        ice: 'COLD'
        fire: 'HOT'
        pine: 'tree'
      fireIceJson =
        ice: 'COLD'
        fire: 'FIRE'
        pine: 'tree'
      bee = new FactoryB default: json
      iceFire = bee.get ice, fire
      fireIce = bee.get fire, ice
      expect(bee.get()).toEqual json
      expect(iceFire).toEqual iceFireJson
      expect(fireIce).toEqual fireIceJson

    it 'should replace any functions with the values returned by those
        functions', ->
      json =
        dog: -> 'bark'
        cat: -> 'meow'
      expectation =
        dog: 'bark'
        cat: 'meow'
      bee = new FactoryB default: json
      expect(bee.get()).toEqual expectation

    it 'should accept multiple keys for saved JSON objects and should return
        default after they are applied to it in order', ->
      json =
        ice: 'cold'
        fire: 'fire'
        pine: 'tree'
      ice =
        ice: 'COLD'
        fire: 'FIRE'
      fire =
        fire: 'HOT'
      iceFireJson =
        ice: 'COLD'
        fire: 'HOT'
        pine: 'tree'
      fireIceJson =
        ice: 'COLD'
        fire: 'FIRE'
        pine: 'tree'
      bee = new FactoryB
        default: json
        ice: ice
        fire: fire
      iceFire = bee.get 'default', 'ice', 'fire'
      fireIce = bee.get 'default', 'fire', 'ice'
      expect(bee.get()).toEqual json
      expect(iceFire).toEqual iceFireJson
      expect(fireIce).toEqual fireIceJson

  describe 'has a set method that', ->

    it 'should accept a key as a string and a JSON object that will be
        retrievable with that key', ->
      json = fur: 'existential'
      bee = new FactoryB
      bee.set('cat', json)
      result = bee.get('cat')
      expect(result).toEqual(json)

    it 'should accept a JSON object that will be retrievable with the key
        default', ->
      json = fur: 'existential'
      bee = new FactoryB
      bee.set(json)
      result = bee.get()
      expect(result).toEqual(json)

  it 'should have a method to get the keys for the JSON objects it stores', ->
    bee = new FactoryB

  describe 'had bugs such that', ->

    it 'Mutator does not accept a Date (#8)', ->
      json = live: 'forever'
      mutator = live: new Date
      bee = new FactoryB
      bee.set(json)
      result = bee.get(mutator)
      expect(result).toEqual mutator
