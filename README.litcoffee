[
![Build Status](https://travis-ci.org/LonelyRobotStudio/FactoryB.png?branch=master)
](https://travis-ci.org/LonelyRobotStudio/FactoryB)


About FactoryB
==============
FactoryB is a fixture solution for Nodejs using simple JSON object storing and
mutating. FactoryB inspired by frustrations with Node.js fixture solutions
that themselves were inspired by Factory_Girl from ThoughtBot.

FactoryB right now does two simple things. It stores JSON under string keys and
allows you to apply changes to them when you retrieve them.

-------------------------------------------------------------------------------

Simple Usage
============

The simplest way you can use FactoryB is requiring it,
  
    FactoryB = require 'FactoryB'

instantiating an instance without arguments,

    bee = new FactoryB

using its set method with one JSON argument,

    jsonArgument = 
      fire: 'fire'
      ice: 'cold'

    bee.set jsonArgument

and then retrieving that JSON with get.

    console.log bee.get()

Storing More Than One JSON object
=================================

FactoryB stores JSON under the key 'default' when it is not given a key.
So the following:

    bee = new FactoryB
    bee.set jsonArgument

is the same as:

    bee = new FactoryB
    bee.set 'default', jsonArgument

Likewise, FactoryB's get uses the 'default' key when not given a key.
so the following:

    console.log bee.get()

is the same as:

    console.log bee.get('default')

If we want to store more JSON we can store it under other keys,

    jsonArgument2 = 
      fire: 'cold'
      ice: 'fire'

    bee.set 'oppositeWorld', jsonArgument2

and then retrieve it using that key:

    console.log bee.get('oppositeWorld')

'default' can still be accessed just like before:

    console.log bee.get()
    console.log bee.get('default')

Setting JSON  With The Constructor
=================================

FactoryB's constructor will also accept a JSON object,
  
    bee = new FactoryB
      default: jsonArgument
      oppositeWorld: jsonArgument2

using its keys and subobjects to populate itself:

    console.log bee.get()
    console.log bee.get('default')
    console.log bee.get('oppositeWorld')

Changing JSON Through The Get method
====================================

FactoryB's get method will accept a JSON object with values to change for keys
in the returned JSON:

    console.log bee.get('oppositeWorld')
    console.log bee.get('oppositeWorld', fire: 'ice')

The JSON you give FactoryB is cloned before set saves and when get retrieves.
So changes do not affect FactoryB or the original object:

    console.log jsonArgument2
    console.log bee.get('oppositeWorld')

When not given a key and just JSON get retrieves what is under the 'default'
key and changes it according to the JSON:

    console.log bee.get()
    console.log bee.get(ice: 'melted')

-------------------------------------------------------------------------------

Future Features
===============

- Iterators
- Knowing its model
- Knowing how its model should be instantiated
- Knowing how its model should be saved
- Object relationship handling
- Mutators saved as traits