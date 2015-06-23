-- TypeTools.moon

T_NONE = {0,0,0,0,0,0,0,0} -- 8-bit NULL padding

class True

-- Not Possible to implement False in MoonScript OOP syntax
False = setmetatable {}, {  
  __call: (...) => error 'Attempt to call boolean value `False`'
  __eq: (other) => other == false
  __ne: (other) => other ~= false
  __ge: (other) => false
  __le: (other) => false
  __gt: (other) => false
  __lt: (other) => false
  __pow: (other) => error 'Attempt to perform arithemtic on boolean value `False`'
  __add: (other) => error 'Attempt to perform arithemtic on boolean value `False`'
  __sub: (other) => error 'Attempt to perform arithemtic on boolean value `False`'
  __div: (other) => error 'Attempt to perform arithemtic on boolean value `False`'
  __mul: (other) => error 'Attempt to perform arithemtic on boolean value `False`'
  __mod: (other) => error 'Attempt to perform arithemtic on boolean value `False`'
  __bor: (other) => other
  __xor: (other) => other
  __band: (other) => false
  __nand: (other) => true
  __bnot: => true
}

bool = (x,...) -> {not not value for value in *{x,...}} if #{...} > 0 else not not x


int = (x) -> x / 1  -- Integer division by one


float = (x) -> x * 1.0  -- Multiplication by Float


stringify = (obj, ...) ->
  items = {obj, ...}
  s = ""
  for item in *items
    if type item == T_TABLE -- item is a Table type
      t = "{"
      for index, value in *item  -- Turn it into a stringified table
        t ..= "[#{index}] = #{stringify value}, "
      s ..= (t\sub 1, #t - 2) .. "}"
    else
      s ..= tostring item
  s


return 
  :T_NONE
  :bool
  :int
  :float
  :string