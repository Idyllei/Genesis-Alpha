-- Naming-Conventions.moon

-- <Files>
-- 
-- Class Files should use -------> ```UpperCamelCase```
-- Core Types: should used ------> ```ALL_CAPS_WITH_UNDERSCORES```
-- Utilities and Tools: should use ```lower-with-dashes```
-- Documentation: should use ----->```Upper-Camel-Case-With-Dashes```

-- <Variables>
-- 
-- All variables should be ------> ```lowerCamelCase``` 
-- except when naming a Class or 
-- optional args.
-- Classes should use -----------> ```UpperCamelCase```
-- Static Class Methods should use ```UpperCamelCase```
-- Optional Arguments: should use  ```UpperCamelCase```
-- Closures and Hidden Functions:
-- should use -------------------> ```UpperCamelCase```
-- Constants should be ----------> ```UPPER_CASE_WITH_UNDERSCORES``` 
-- for ease of differentiation.
-- When a variable name would cause
-- a built-in conflict, add an underscore.
-- Class variables should follow 
-- normal conventions.

-- Singleton Classes should be named with one of the following prefixes:
-- X_  :  Extended class
-- T_  :  Type Class (for an operation, should have all approriate 
--        metamethods defined)
-- K_  :  Constant Singleton for organization only.
-- U_  :  Utility tool (Ex. HashFunc, UUIDGen, etc.)

-- Style:
-- Vanilla Lua function-call syntax is used when using the
-- Type(obj) functions to cnvert to a built-in type.
-- Ex. Bool(@_SETTINGS[settingName])
-- NOT: Bool @_SETTINGS[settingName]
-- ATTENTION: ALL Classes MUST have explicit names!
-- Using implicit naming can lead to incorrect variable
-- usage or improper class naming.
-- Ex. class Bucket  -- Built-in tools work as expected.
-- NOT: Bucket = class  -- Bad variable naming convention

-- <Examples>

RATIO_OF_CIRCUMFERENCE_OF_CIRCLE_TO_DIAMETER = 3.141592653  -- Constant pi
BASE_NATURAL_LOG = 2.718281828  -- Constant e

class OrderedDictionary
  new: (...) =>
    @rawDict = {{index, value} for index, value in pairs {...}}
    @sort!

  sort: => @@rawDict\sort (a,b) -> a[1] < b[1]

                      -- `_rawDict_name` is name-mangled `rawDict.__name`
  name: (n) => @rawDict._rawDict_name = tostring n

  get: (key) =>
    for t in *@@rawDict
      for index, _ in pairs t
        return t[2] if index == key

  set: (key, value) =>
    @@rawDict\insert {key, value}
    @sort!

  add: (...) =>
    kvPairs = {{{...}[i], {...}[i+1]} for i = 1, #{...}, 2}  -- Every pair of 2 elements.
    @@rawDict\insert pair for pair in *kvPairs
    @sort!

  keys: => {kvPair[1] for kvPair in *rawDict}

  values: => {kvPair[2] for kvPair in *rawDict}

  getRaw: => @rawDict


