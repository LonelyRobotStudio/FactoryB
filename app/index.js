(function() {
  var FactoryB,
    __slice = [].slice;

  module.exports = FactoryB = (function() {
    var clone, cloneArray, cloneDate, cloneObject, mutate, runValue;

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
        if (value === null || typeof value !== 'object' || value instanceof Date) {
          data[key] = value;
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
      if (obj === null || typeof obj !== 'object') {
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

    runValue = function(value) {
      var index, subvalue, _ref;
      if (value === null || typeof value !== 'object' || value instanceof Date) {
        value = (_ref = typeof value === "function" ? value() : void 0) != null ? _ref : value;
      } else if (value instanceof Object) {
        for (index in value) {
          subvalue = value[index];
          value[index] = runValue(subvalue);
        }
      }
      return value;
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
        var _i, _len, _ref, _results;
        _results = [];
        for (_i = 0, _len = mutators.length; _i < _len; _i++) {
          mutator = mutators[_i];
          _results.push(clone((_ref = this.data[mutator]) != null ? _ref : mutator));
        }
        return _results;
      }).call(this);
      return runValue(mutators.reduce(mutate));
    };

    FactoryB.prototype.keys = function() {
      return this.data.keys();
    };

    return FactoryB;

  })();

}).call(this);
