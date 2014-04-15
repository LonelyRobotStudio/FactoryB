[
![Build Status](https://travis-ci.org/LonelyRobotStudio/FactoryB.png?branch=master)
](https://travis-ci.org/LonelyRobotStudio/FactoryB)


About FactoryB
==============

FactoryB is a fixture solution for Node.js using simple JSON object storing and mutating. FactoryB is inspired by frustrations with other Node.js fixture solutions that, themselves, were inspired by Factory_Girl (from ThoughtBot).

FactoryB is a dictionary that does two simple things:

1. It stores JSON objects under string keys and
2. Allows you to apply changes to those objects when you retrieve them.

The following examples are provided in CoffeeScript.



Simple Usage
------------

The simplest way you can use FactoryB is requiring it,
  
    FactoryB = require 'FactoryB'

instantiating an instance without arguments,

    bee = new FactoryB

using its `set()` method with one JSON argument,

    jsonArgument = 
      fire: 'hot'
      ice: 'cold'

    bee.set jsonArgument

and then retrieving that JSON object with `get()`.

    console.log bee.get()

    # OUTPUT> {fire: 'hot', ice: 'cold'}



Storing More Than One JSON Object
---------------------------------

FactoryB stores JSON dictionary entries under the key `'default'` when it is not given a key.
So the following:

    bee = new FactoryB
    bee.set jsonArgument

is the same as:

    bee = new FactoryB
    bee.set 'default', jsonArgument

Likewise, FactoryB's `get()` uses the `'default'` key when not given a key. So, the following:

    bee.get

is the same as:

    bee.get 'default'

If we want to store more JSON we can store it under other keys,

    jsonArgument2 = 
      fire: 'cold'
      ice: 'hot'

    bee.set 'oppositeWorld', jsonArgument2

and then retrieve it using those keys:

    console.log bee.get('oppositeWorld')

    # OUTPUT> {fire: 'cold', ice: 'hot'}

`'default'` can still be accessed just like before:

    console.log bee.get()
    console.log bee.get('default')

    # OUTPUT> {fire: 'hot', ice: 'cold'}
    # OUTPUT> {fire: 'hot', ice: 'cold'}

Setting JSON with the Constructor
--------------------------------

FactoryB's constructor will also accept a JSON object, using its keys and subobject values to populate the dictionary:
  
    bee = new FactoryB
      default: jsonArgument
      oppositeWorld: jsonArgument2

Retrieval is the same:

    console.log bee.get()
    console.log bee.get('default')
    console.log bee.get('oppositeWorld')

    # OUTPUT> {fire: 'hot', ice: 'cold'}
    # OUTPUT> {fire: 'hot', ice: 'cold'}
    # OUTPUT> {fire: 'cold', ice: 'hot'}



Changing JSON Through the `get()` Method
----------------------------------------

FactoryB's `get()` method will accept a JSON object with values to change for the keys provided. The returned JSON will reflect the change.

    console.log bee.get('oppositeWorld', fire: 'DARK')

    # OUTPUT> {fire: 'DARK', ice: 'hot'}

FactoryB protects your objects from being passed by reference. The JSON you give FactoryB is cloned before `set()` saves and when `get()` retrieves; so, changes do *not* affect either FactoryB's state *or* any of the arguments you pass it.

    console.log jsonArgument2
    console.log bee.get('oppositeWorld')

    # OUTPUT> {fire: 'cold', ice: 'hot'}
    # OUTPUT> {fire: 'cold', ice: 'hot'}

When given JSON without a key, `get()` retrieves what is under the `'default'` key and changes it accordingly:

    console.log bee.get()
    console.log bee.get(ice: 'MELTED')

    # OUTPUT> {fire: 'hot', ice: 'cold'}
    # OUTPUT> {fire: 'hot', ice: 'MELTED'}



Chaining Saved JSON as Changes to Retrieved JSON
------------------------------------------------

FactoryB's `get()` meth will accept multiple JSON objects applying them in the
order given.

    time =
      fire: 'out'
      ice: 'melted'

    reignite =
      fire: 'HOT'

    console.log bee.get('default', time, reignite)

    # OUTPUT> {fire: 'HOT', ice: 'melted'}



Future Features
---------------

- Iterators
- Knowing its model
- Knowing how its model should be instantiated
- Knowing how its model should be saved
- Object relationship handling
- Mutators saved as traits