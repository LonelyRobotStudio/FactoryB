(function() {
  var FactoryB,
    __slice = [].slice;

  module.exports = FactoryB = (function() {
    var _clone, _cloneArray, _cloneDate, _cloneObject, _mutate;

    FactoryB._factories = {};

    FactoryB.set = function(name, factory) {
      return this._factories[name] = factory;
    };

    FactoryB.get = function(name) {
      return this._factories[name];
    };

    FactoryB.keys = function() {
      return this._factories.keys();
    };

    function FactoryB(name, data) {
      var key, value;
      if (data == null) {
        data = name;
      }
      if (typeof name === 'string') {
        FactoryB.set(name, this);
      }
      this.data = {
        "default": {}
      };
      for (key in data) {
        value = data[key];
        this.set(key, value);
      }
    }

    _mutate = function(data, mutator) {
      var key, value;
      for (key in mutator) {
        value = mutator[key];
        if (value === null || typeof value !== 'object' || value instanceof Date || value instanceof Array) {
          if (value instanceof Function) {
            data[key] = value(data != null ? data[key] : void 0);
          } else {
            data[key] = value;
          }
        } else {
          data[key] = _mutate(data[key], value);
        }
      }
      return data;
    };

    _cloneDate = function(date) {
      return new Date(date.getTime());
    };

    _cloneArray = function(array) {
      var value, _results;
      _results = [];
      for (value in array) {
        _results.push(_clone(value));
      }
      return _results;
    };

    _cloneObject = function(object) {
      var copy, key, value;
      copy = {};
      for (key in object) {
        value = object[key];
        if (object.hasOwnProperty(key)) {
          copy[key] = _clone(value);
        }
      }
      return copy;
    };

    _clone = function(obj) {
      if (obj === null || typeof obj !== 'object') {
        return obj;
      }
      if (obj instanceof Date) {
        return _cloneDate(obj);
      }
      if (obj instanceof Array) {
        return _cloneArray(obj);
      }
      if (obj instanceof Object) {
        return _cloneObject(obj);
      }
      throw new Error("Unable to copy object! Its type isn't supported.");
    };

    FactoryB.prototype.set = function(key, data) {
      if (key == null) {
        key = 'default';
      }
      if (key instanceof Object && key instanceof String !== true) {
        data = key;
        key = 'default';
      }
      if (data !== null) {
        return this.data[key] = _clone(data);
      }
    };

    FactoryB.prototype.get = function() {
      var mutator, mutators;
      mutators = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (typeof mutators[0] !== 'string') {
        mutators.unshift('default');
      }
      mutators = (function() {
        var _i, _len, _ref, _results;
        _results = [];
        for (_i = 0, _len = mutators.length; _i < _len; _i++) {
          mutator = mutators[_i];
          _results.push(_clone((_ref = this.data[mutator]) != null ? _ref : mutator));
        }
        return _results;
      }).call(this);
      mutators.unshift({});
      return mutators.reduce(_mutate);
    };

    FactoryB.prototype.keys = function() {
      return this.data.keys();
    };

    return FactoryB;

  })();

}).call(this);
