(function() {
  describe("Truth", function() {
    return it("should be true", function() {
      return expect(true).toBeTruthy();
    });
  });

  describe('Factory B', function() {
    var FactoryB;
    try {
      FactoryB = require('../src');
    } catch (_error) {
      FactoryB = require('../app');
    }
    describe('has a constructor that', function() {
      it('should accept nothing', function() {
        var bee;
        bee = new FactoryB;
        return expect(bee).not.toBeNull();
      });
      it('should accept a JSON object with sub-objects', function() {
        var bee;
        bee = new FactoryB({
          tree: {
            frog: 'danny',
            squirrel: 'timmy'
          },
          "default": {
            house: 'round',
            dog: 'square'
          }
        });
        return expect(bee).not.toBeNull();
      });
      return it('should know its instantiations', function() {
        var bee1;
        bee1 = new FactoryB('bee1', {
          "default": "default"
        });
        return expect(FactoryB.get('bee1')).toEqual(bee1);
      });
    });
    describe('has a get method that', function() {
      it('should accept nothing and return a JSON object held under the key \'default\'', function() {
        var bee, json;
        json = {
          frog: 'jump',
          bacon: 'delicious'
        };
        bee = new FactoryB({
          "default": json
        });
        return expect(bee.get()).toEqual(json);
      });
      it('should accept a string as a key and return a JSON object held under that key', function() {
        var bee, json;
        json = {
          frog: 'jump',
          bacon: 'delicious'
        };
        bee = new FactoryB({
          json: json
        });
        return expect(bee.get('json')).toEqual(json);
      });
      it('should accept a string as a key and a JSON object as mutator and reuturn an altered JSON object', function() {
        var bee, expectedJson, json, mutator, originalJson, result;
        originalJson = {
          ice: 'cold',
          fire: 'fire'
        };
        json = {
          ice: 'cold',
          fire: 'fire'
        };
        expectedJson = {
          ice: 'melted',
          fire: 'fire'
        };
        mutator = {
          ice: 'melted'
        };
        bee = new FactoryB({
          json: json
        });
        result = bee.get('json', mutator);
        expect(result).not.toEqual(originalJson);
        return expect(result).toEqual(expectedJson);
      });
      it('should accept a JSON object as a mutator and return the JSON object under the default key altered', function() {
        var bee, expectedJson, json, mutator, originalJson, result;
        originalJson = {
          ice: 'cold',
          fire: 'fire'
        };
        json = {
          ice: 'cold',
          fire: 'fire'
        };
        expectedJson = {
          ice: 'melted',
          fire: 'fire'
        };
        mutator = {
          ice: 'melted'
        };
        bee = new FactoryB({
          "default": json
        });
        result = bee.get(mutator);
        expect(result).not.toEqual(originalJson);
        return expect(result).toEqual(expectedJson);
      });
      it('should not alter the contents of a key when mutating objects', function() {
        var bee, expectedJson, json, mutator, originalJson, result, result2;
        originalJson = {
          ice: 'cold',
          fire: 'fire'
        };
        json = {
          ice: 'cold',
          fire: 'fire'
        };
        expectedJson = {
          ice: 'melted',
          fire: 'fire'
        };
        mutator = {
          ice: 'melted'
        };
        bee = new FactoryB({
          "default": json
        });
        result = bee.get(mutator);
        result2 = bee.get();
        expect(result).toEqual(expectedJson);
        return expect(result2).toEqual(originalJson);
      });
      it('should accept multiple JSON objects and should return default after they are applied to it in order', function() {
        var bee, fire, fireIce, fireIceJson, ice, iceFire, iceFireJson, json;
        json = {
          pine: 'tree',
          ice: 'cold',
          fire: 'fire'
        };
        ice = {
          ice: 'COLD',
          fire: 'FIRE'
        };
        fire = {
          fire: 'HOT'
        };
        iceFireJson = {
          ice: 'COLD',
          fire: 'HOT',
          pine: 'tree'
        };
        fireIceJson = {
          ice: 'COLD',
          fire: 'FIRE',
          pine: 'tree'
        };
        bee = new FactoryB({
          "default": json
        });
        iceFire = bee.get(ice, fire);
        fireIce = bee.get(fire, ice);
        expect(bee.get()).toEqual(json);
        expect(iceFire).toEqual(iceFireJson);
        return expect(fireIce).toEqual(fireIceJson);
      });
      it('should replace any functions with the values returned by those functions', function() {
        var bee, expectation, json;
        json = {
          dog: function() {
            return 'bark';
          },
          cat: function() {
            return 'meow';
          }
        };
        expectation = {
          dog: 'bark',
          cat: 'meow'
        };
        bee = new FactoryB({
          "default": json
        });
        return expect(bee.get()).toEqual(expectation);
      });
      it('should pass functions the values of the previous JSON', function() {
        var bee, change, expected, original;
        original = {
          dog: 'bark',
          cat: 'bark'
        };
        change = {
          cat: function(prev) {
            return prev + ' bark';
          }
        };
        expected = {
          dog: 'bark',
          cat: 'bark bark'
        };
        bee = new FactoryB({
          "default": original
        });
        return expect(bee.get(change)).toEqual(expected);
      });
      return it('should accept multiple keys for saved JSON objects and should return default after they are applied to it in order', function() {
        var bee, fire, fireIce, fireIceJson, ice, iceFire, iceFireJson, json;
        json = {
          ice: 'cold',
          fire: 'fire',
          pine: 'tree'
        };
        ice = {
          ice: 'COLD',
          fire: 'FIRE'
        };
        fire = {
          fire: 'HOT'
        };
        iceFireJson = {
          ice: 'COLD',
          fire: 'HOT',
          pine: 'tree'
        };
        fireIceJson = {
          ice: 'COLD',
          fire: 'FIRE',
          pine: 'tree'
        };
        bee = new FactoryB({
          "default": json,
          ice: ice,
          fire: fire
        });
        iceFire = bee.get('default', 'ice', 'fire');
        fireIce = bee.get('default', 'fire', 'ice');
        expect(bee.get()).toEqual(json);
        expect(iceFire).toEqual(iceFireJson);
        return expect(fireIce).toEqual(fireIceJson);
      });
    });
    describe('has a set method that', function() {
      it('should accept a key as a string and a JSON object that will be retrievable with that key', function() {
        var bee, json, result;
        json = {
          fur: 'existential'
        };
        bee = new FactoryB;
        bee.set('cat', json);
        result = bee.get('cat');
        return expect(result).toEqual(json);
      });
      return it('should accept a JSON object that will be retrievable with the key default', function() {
        var bee, json, result;
        json = {
          fur: 'existential'
        };
        bee = new FactoryB;
        bee.set(json);
        result = bee.get();
        return expect(result).toEqual(json);
      });
    });
    it('should have a method to get the keys for the JSON objects it stores', function() {
      var bee;
      return bee = new FactoryB;
    });
    describe('has methods for knowing its model and creating documents that', function() {
      var TestClass, expectedDocument, testJSON;
      TestClass = (function() {
        function TestClass(parameters) {
          var key, value, _i, _len;
          for (value = _i = 0, _len = parameters.length; _i < _len; value = ++_i) {
            key = parameters[value];
            this[key] = value;
          }
        }

        TestClass.create = function(parameters) {
          return (new TestClass(parameters)).save();
        };

        TestClass.prototype.save = function() {};

        return TestClass;

      })();
      testJSON = {
        frog: 'jump',
        cheese: 'wheel'
      };
      expectedDocument = new TestClass(testJSON);
      it('should include a method that accepts a model', function() {
        var bee;
        bee = new FactoryB({
          "default": testJSON
        });
        return expect(function() {
          return bee.setModel(TestClass);
        }).not.toThrow();
      });
      it('should include a method that returns a document built from the given model and stored object', function() {
        var bee;
        bee = new FactoryB({
          "default": testJSON
        });
        bee.setModel(TestClass);
        return expect(bee.build()).toEqual(expectedDocument);
      });
      return it('should include a method that sets how Factory builds the document', function() {
        var bee, buildMethod, flag;
        bee = new FactoryB({
          "default": testJSON
        });
        bee.setModel(TestClass);
        flag = false;
        buildMethod = function(data, model) {
          flag = true;
          return new model(data);
        };
        bee.setBuild(buildMethod);
        expect(bee.build()).toEqual(expectedDocument);
        return expect(flag).toEqual(true);
      });
    });
    return describe('had bugs such that', function() {
      it('Mutator does not accept a Date (#8)', function() {
        var bee, json, mutator, result;
        json = {
          live: 'forever'
        };
        mutator = {
          live: new Date
        };
        bee = new FactoryB;
        bee.set(json);
        result = bee.get(mutator);
        return expect(result).toEqual(mutator);
      });
      return it('Nested JSON is not being processed as expected #31', function() {
        var bee, options;
        options = {
          hostname: '127.0.0.1',
          port: 3000,
          path: '/users',
          method: 'GET',
          headers: {
            accept: 'text/json+hal'
          }
        };
        bee = new FactoryB({
          "default": options
        });
        return expect(bee.get()).toEqual(options);
      });
    });
  });

}).call(this);
