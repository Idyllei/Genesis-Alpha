local M = {f={Object={}}};

function M.setup()
  setfenv(1,{unpack(getfenv(1)),unpack(M.f)});
end


function M.f.boost_foreach(var,tab,func) -- M.foreach("player",game.Players:GetPlayers(),function() print(player.Name); end);
  for _,v in pairs(tab)do
    loadstring("setfenv(func,{unpack(getfenv(func)),"..var.."=v});")();
    func();
  end
end

function M.f.foreach(tab,f) -- Perl `foreach'
  for _,v in pairs(tab) do
    f(v);
  end
end

function M.f.die(...) -- Perl `die' | Short for: function(...) error(...); return; end
  local t={...};
  if (type(t[-1])=="number") then
    error(table.concat(t,"|",1,#t-2),t[-1]);
  else
    error(table.concat(t,"|",1,#t),0);
  end
  return;
end

-- Object is the base class of ALL new classes.
-- Object:new(Object parent1[,Object parent2[,...]]) 
-- Calling Object:new() with one parameter creates a new Object with a single parent, calling with multiple arguments
-- creates a new Object with multiple inheritance.
function M.f.Object:new(...)
  local function search (k, plist)
    for i=1, #plist do
      local v = plist[i][k]     -- try `i'-th superclass
      if v then return v end
    end
  end
  -- look up for `k' in list of tables `plist'
  if (#{...}<=1) then
    local o = ... or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
  else
    local c = {};        -- new class
    -- class will search for each method in the list of its
    -- parents (`arg' is the list of parents)
    local pars={...};
    setmetatable(c, {__index = function (t, k)
      return search(k,pars)
    end});
    -- prepare `c' to be the metatable of its instances
    c.__index = c;
    -- define a new constructor for this new class
    function c:new (...)
      return Object:new(...);
    end
    -- return new class
    return c
  end
end

function M.f.Object:delete()
  for i,_ in pairs({unpack(self),unpack(self.__index)}) do
    if (rawget(self, i)) then
      self[i]=nil;
    else
      self.__index[i]=nil;
    end
  end
  self.__mode="kv";
end
-- -------------------------------------- ~nullptr~ --------------------------------------
-- nullptr type is NOT of class `Object`
M.f.nullptr=setmetatable(newproxy(true),{__index={new=function(self,...) if (#{...}<=1) then die("Attempt to create `new` nullptr type.",2); else die("Attempt to set nullptr type as superclass of new Object.",2);end end,delete=function(self) die("Attempt to `delete` nullptr type. (Potential memory leak).",2); end},
__newindex=function(self,i,v) die("nullptr.__newindex|Attempt to set index of nullptr type.",2); end,
__eq=function(self,other) die("nullptr.__eq|Attempt to perform comparison with nullptr type.",2); end,
__lt=function(self,other) die("nullptr.__lt|Attempt to perform comparison with nullptr type.",2); end,
__le=function(self,other) die("nullptr.__le|Attempt to perform comparison with nulltpr type.",2); end,
__call=function(self,...) die("nullptr.__call|Attempt to call nullptr type as a method.",2); end,
__concat=function(self,sep) die("nullptr.__concat|Attempt to concatenate "..type(sep).." value with nullptr type.",2); end,
__tostring=function(self) die("nullptr.__tostring|Attempt to perform coercion on nullptr value.",2); end,
__gc=function(self) print("[DEBUG][Help]::nullptr.__gc|nullptr userdata is being collected by GC at tick: "..tick().." and os.time(): "..os.time(table)); end});
-- -------------------------------------- ~nullptr~ --------------------------------------

return M;