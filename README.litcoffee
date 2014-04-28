[
![Build Status](
  https://travis-ci.org/LonelyRobotStudio/FactoryB.png?branch=master
  )
](https://travis-ci.org/LonelyRobotStudio/FactoryB)

[
![NPM](https://nodei.co/npm/factoryb.png?downloads=true)
](https://nodei.co/npm/factoryb/)

About FactoryB
==============

FactoryB is a fixture solution for Node.js using simple JSON object storing and
mutating. FactoryB is inspired by frustrations with other Node.js fixture
solutions that, themselves, were inspired by Factory_Girl (from ThoughtBot).

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

FactoryB stores JSON dictionary entries under the key `'default'` when it is not
 given a key.
So the following:

    bee = new FactoryB
    bee.set jsonArgument

is the same as:

    bee = new FactoryB
    bee.set 'default', jsonArgument

Likewise, FactoryB's `get()` uses the `'default'` key when not given a key. So,
the following:

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

FactoryB's constructor will also accept a JSON object, using its keys and
subobject values to populate the dictionary:


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

FactoryB's `get()` method will accept a JSON object with values to change for
the keys provided. The returned JSON will reflect the change.

    console.log bee.get('oppositeWorld', fire: 'DARK')

    # OUTPUT> {fire: 'DARK', ice: 'hot'}

FactoryB protects your objects from being passed by reference. The JSON you give
FactoryB is cloned before `set()` saves and when `get()` retrieves; so, changes
do *not* affect either FactoryB's state *or* any of the arguments you pass it.

    console.log jsonArgument2
    console.log bee.get('oppositeWorld')

    # OUTPUT> {fire: 'cold', ice: 'hot'}
    # OUTPUT> {fire: 'cold', ice: 'hot'}

When given JSON without a key, `get()` retrieves what is under the `'default'`
key and changes it accordingly:

    console.log bee.get()
    console.log bee.get(ice: 'MELTED')

    # OUTPUT> {fire: 'hot', ice: 'cold'}
    # OUTPUT> {fire: 'hot', ice: 'MELTED'}



Creating Dynamic Values Using Functions
---------------------------------------

When JSON objects are retrieved using the `get` method any functions in the
object are run and replaced with their return values.

    ones = 1
    twos = 2

    numberWang =
      ones: -> ones += ones
      twos: -> twos + twos
    numberBee = new FactoryB default: numberWang
    console.log numberBee.get()
    # OUTPUT> {ones: 2, twos:4}
    console.log numberBee.get()
    # OUTPUT> {ones: 4, twos:4}

Variables scoped outside these functions can be changed to change the results of
the functions.

    ones = 1
    twos = 5
    console.log numberBee.get()
    # OUTPUT> {ones: 2, twos:10}

Functions are also passed the previous value in the chain of mutators allowing
programmatic changes.

    dogs =
      description: "dog list"
      dogs: [
        "Snoopy"
      ]

    addScooby =
      dogs: (prev)->
        prev.push "Scooby"
        return prev

    pound = new FactoryB default: dogs
    console.log pound.get 'default', addScooby

    # OUTPUT> {description: "dog list", dogs: ["Snoopy", "Scooby"]}



Chaining Saved JSON as Changes to Retrieved JSON
------------------------------------------------

FactoryB's `get()` method will accept multiple JSON objects applying them in the
order given.

    time =
      fire: 'out'
      ice: 'melted'

    reignite =
      fire: 'HOT'

    console.log bee.get('default', time, reignite)

    # OUTPUT> {fire: 'HOT', ice: 'melted'}

When it doesn't get a key first, it still assumes changes are to default.

    console.log bee.get(time, reignite)

    # OUTPUT> {fire: 'HOT', ice: 'melted'}

When given keys, the `get()` method will use JSON objects it has saved at those
keys.

    bee.set 'time', time
    bee.set 'reignite', reignite

    console.log bee.get('default', 'time', 'reignite')

    # OUTPUT> {fire: 'HOT', ice: 'melted'}

`get()` will also mix and match accordingly.

    console.log bee.get('default', time, 'reignite')

    # OUTPUT> {fire: 'HOT', ice: 'melted'}



Managing Multiple Factories With The Constructor
------------------------------------------------

The FactoryB constructor will track any factories that are instantiated with a
name string, which can then be retrieved using `get()` on the contructor.

    honeyBee = new FactoryB 'honeyBee', default: collects: 'honey'
    fireBee = new FactoryB 'fireBee', default: collects: 'fire'

    console.log FactoryB.get('honeyBee').get()
    console.log FactoryB.get('fireBee').get()

    # OUTPUT> {collects: 'honey'}
    # OUTPUT> {collects: 'fire'}

The FactoryB constructor also has a `set()` method, if you decide you want the
constructor to track it after instantiation.

    iceBee = new FactoryB default: collects: 'ice'
    FactoryB.set 'iceBee', iceBee

    console.log FactoryB.get('iceBee').get()

    # OUTPUT> {collects: 'ice'}



Future Features
---------------

- Better array handling
- Knowing its model
- Knowing how its model should be instantiated
- Knowing how its model should be saved
- Object relationship handling
