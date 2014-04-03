(function() {
  var FactoryB;

  module.exports = FactoryB = (function() {
    var clone, mutate;

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

    clone = function(data) {
      if (data == null) {
        data = {};
      }
      return JSON.parse(JSON.stringify(data));
    };

    FactoryB.prototype.set = function(key, data) {
      if (typeof key !== 'string' && typeof key === 'object' && key !== null) {
        data = clone(key);
        key = 'default';
      }
      if (data !== null) {
        return this.data[key] = clone(data);
      }
    };

    FactoryB.prototype.get = function(key, mutator) {
      if (key == null) {
        key = 'default';
      }
      if (mutator == null) {
        mutator = {};
      }
      if (typeof key !== 'string') {
        mutator = key;
        key = 'default';
      }
      return mutate(clone(this.data[key]), mutator);
    };

    FactoryB.prototype.keys = function() {
      return data.keys();
    };

    return FactoryB;

  })();

}).call(this);
