(function() {
  var FactoryB,
    __slice = [].slice;

  module.exports = FactoryB = (function() {
    var clone, cloneArray, cloneDate, cloneObject, mutate;

    function FactoryB(data) {
      var key, value;
      if (data == null) {
        data = {};
      }
      this.data = {};
      for (key in data) {
        value = data[key];
        this.set(key, value);
      }
      if (this.data["default"] == null) {
        this.data["default"] = {};
      }
    }

    mutate = function(data, mutator) {
      var key, value;
      if (data == null) {
        data = {};
      }
      for (key in mutator) {
        value = mutator[key];
        if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean' || value === null) {
          data[key] = value;
        } else if (value instanceof Date) {
          data[key] = new Date(value);
        } else {
          data[key] = mutate(data[key], value);
        }
      }
      return data;
    };

    cloneDate = function(date) {
      return new Date(date.getTime());
    };

    cloneArray = function(array) {
      var value, _results;
      _results = [];
      for (value in array) {
        _results.push(clone(value));
      }
      return _results;
    };

    cloneObject = function(object) {
      var copy, key, value;
      copy = {};
      for (key in object) {
        value = object[key];
        if (object.hasOwnProperty(key)) {
          copy[key] = clone(value);
        }
      }
      return copy;
    };

    clone = function(obj) {
      if (obj == null) {
        obj = {};
      }
      if (null === obj || "object" !== typeof obj) {
        return obj;
      }
      if (obj instanceof Date) {
        return cloneDate(obj);
      }
      if (obj instanceof Array) {
        return cloneArray(obj);
      }
      if (obj instanceof Object) {
        return cloneObject(obj);
      }
      throw new Error("Unable to copy object! Its type isn't supported.");
    };

    FactoryB.prototype.set = function(key, data) {
      if (key == null) {
        key = 'default';
      }
      if (key instanceof Object && key instanceof String !== true) {
        data = clone(key);
        key = 'default';
      }
      if (data !== null) {
        return this.data[key] = clone(data);
      }
    };

    FactoryB.prototype.get = function() {
      var mutator, mutators;
      mutators = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (typeof mutators[0] !== 'string') {
        mutators.unshift('default');
      }
      mutators = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = mutators.length; _i < _len; _i++) {
          mutator = mutators[_i];
          if (typeof mutator === 'string') {
            if (this.data[mutator] != null) {
              _results.push(clone(this.data[mutator]));
            } else {
              throw new Error("Object not found for key: " + mutator);
            }
          } else {
            _results.push(clone(mutator));
          }
        }
        return _results;
      }).call(this);
      return mutators.reduce(mutate);
    };

    FactoryB.prototype.keys = function() {
      return this.data.keys();
    };

    return FactoryB;

  })();

}).call(this);
