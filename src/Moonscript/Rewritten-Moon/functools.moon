-- functools.moon

{:T_NONE, :bool, :int, :float} = require "TypeTools"


map = (f, seq={}, Default=nil) -> {(f val) or Default for val in seq}


apply = (f, seq={}, Default=nil) -> 
  seq[index] = {(f val) or Default for index, val in pairs seq}
  seq


none = (f, seq={}, Default=nil) ->
  for val in *seq
    false if f val -- `return false if f val` ?
  true


all = (f, seq={}, Default=nil) ->
  for val in *seq
    false unless f val
  true


any = (f=((in_) -> return not not in_), seq={}) ->
  for val in *seq
    true if f val
  false


-- KeepIndexIntegrity keeps the same key-value pairs if the value is tested true by function `f`
-- IndexUsedInTest forces the index of the value to be passed in as first arg to truth function
-- NOTE: function f MUST be take the VALUE arg BEFORE the INDEX arg!
filter = (f=((val_,index_) -> not not val_), seq={}, 
          BaseReturn={}, 
          KeepIndexIntegrity=true, 
          IndexUsedInTest=false) ->

  ret = BaseReturn

  TestFunc = (i, v using ret) -> -- Does the processing for us
    if IndexUsedInTest
      -- return Truthiness,Value, NewIndex
      return (f v, i), v, (i if KeepIndexIntegrity else #ret+1)
    else 
      return (f v), v, (i if KeepIndexIntegrity else #ret+1)

  for index,value in pairs seq -- Go through every Key-Value pair
    {isTrue, newValue, newIndex} = TestFunc value, index -- and test them for filtering
    if isTrue -- filter them
      ret[newIndex] = newValue

  return ret
      

filter_poly_all =  (filters = {(val_,index_ using ret) -> not not val_, val_, (index_ if KeepIndexIntegrity else #ret+1)}, 
                    seq={}, 
                    KeepIndexIntegrity=true, 
                    IndexUsedInTest=false,
                    BaseReturn={}
                   ) ->

  ret = {}

  TestFunc = (f, i, v using ret) -> -- Does the processing for us
    if IndexUsedInTest
      -- return Truthiness,Value, NewIndex
      return (f v, i), v, (i if KeepIndexIntegrity else #ret+1)
    else 
     return  (f v), v, (i if KeepIndexIntegrity else #ret+1)

  -- Filtering Code
  for filter in *filters
    for index, value in *(ret if #ret > 0 else seq) -- Use the already partially-sorted ret
                                                    -- unless this is the first sorting stage
      {isTrue, newValue, newIndex} = TestFunc filter, value, index
      if isTrue -- filter
        ret[newIndex] = newValue -- filter and/or modify
      else -- remove it if it fails the test
        table.remove ret, index if ret[index]

  return ret -- the sorted list of elements


filter_poly_any =  (filters={(val_,index_) -> not not val_},
                    seq={},
                    KeepIndexIntegrity=true, 
                    IndexUsedInTest=false,
                    ModifyFunc = ((val_, index_) -> val_, index_)
                   ) ->

  ret = {}

  filter_results = {} -- Set up the Filter results table
  for _ in *filters
    filter_results[i] = false
    i += 1

  for index, value in *seq -- Test every value
    isTrue = true
    for filter in *filters
      export isTrue
      isTrue = false unless isTrue else bool filter value, index -- Calculate truthiness if not false
    if isTrue
      export ret
      {newValue, newIndex} = ModifyFunc value, index
      ret[newIndex] = newValue

  return ret


filter_poly_none =  (filters={(val_,index_) -> not not val_},
                    seq={},
                    KeepIndexIntegrity=true, 
                    IndexUsedInTest=false,
                    ModifyFunc = ((val_, index_) -> val_, index_)
                   ) ->

  ret = {}

  filter_results = {} -- Set up the Filter results table
  for _ in *filters
    filter_results[i] = false
    i += 1

  for index, value in *seq -- Test every value
    isTrue = true
    for filter in *filters
      export isTrue
      isTrue = false unless isTrue else bool filter value, index -- Calculate truthiness if not false
    unless isTrue -- Not true
      export ret
      {newValue, newIndex} = ModifyFunc value, index
      ret[newIndex] = newValue

  return ret


-- TEST THE TOOLS:
start_map = {1,2,3,4,5,6,7,8,9,10}
result_map = {1,4,9,16,25,36,49,64,81,100}
test_result_map = map ((x)->x*x), start_map
print "Result for map test should be: {1,4,9,16,25,36,49,64,81,100}"
print "Result is: {" .. test_result_map\concat "," .. "}"
assert test_result_map == result_map

start_apply = {1,2,3,4,5,6,7,8,9,10}
result_apply = {1,4,9,16,25,36,49,64,81,100}
apply ((x)->x*x), start_apply
assert start_apply == result_apply

atart_any = {1,2,3,4,5,6,7,8,9,10}
result_any = true
test_result_any = any ((x)->x%2==0), start_any
assert test_result_any

start_all = {1,2,3,4,5,6,7,8,9,10}
result_all = false
test_result_all = all ((x)->x*x), start_all
assert test_result_all

start_none = {1,2,3,4,5,6,7,8,9,10}
result_none = false
test_result_none = none ((x)->x*x), start_none
assert test_result_none

start_filter = {1,2,3,4,5,6,7,8,9,10}
result_filter = {2,4,6,8,10}
test_result_filter = filter ((x)->x%2==0), start_filter
assert test_result_filter == result_filter

start_filter_poly_any = {1,2,3,4,5,6,7,8,9,10}
filters_filter_poly_any = {
  ((x)->x%2==0),
  ((x)->x%3==0)
}
modify_filter_poly_any = (val, _) -> x+1
result_filter_poly_any = {3,4,5,7,9,10,11}
test_result_filter_poly_any = filter_poly_any filters_filter_poly_any, start_filter_poly_any, true, false, modify_filter_poly_any
assert test_result_filter_poly_any == result_filter_poly_any

return 
  :map
  :apply
  :any
  :all
  :none
  :filter
  :filter_poly_any
  :filter_poly_all
  :filter_poly_none