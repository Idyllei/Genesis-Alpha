-- Genesis/src/objMana.lua
--- 
-- @author Spencer Tupis
-- @copyright 2014-2015 Spencer Tupis
-- @release Module$Core$Object$objMana$ModuleScript
-- @class module

local API=require("API");

local mana={__CLASS="$mana",player="",baseMax=100,absMax=10000,remaining=100,experience={level=0,amt=0}};
local mt = {
  __index=function(self,index)
    if (rawget(self,index)) then
      return rawget(self,index);
    end --endif
    error("[DEBUG][ERROR][objMana]::__index | Attempt to index invalid value.",2)
  end, --endfunction __index
  __newindex=function(self,index,value)
    error("[DEBUG][ERROR][objMana]::__newindex | Attempt to create new index on locked Object.",2)
  end, --endfunction __newindex
  __call = function(self,...)
    print("[DEBUG][objMana]::__call Called with:'", unpack(...),"'");
  end, --endfunction __call
  __concat=function(self,other)
    if ((type(other)~="string") or (type(other)~="number")) then
      error("[DEBUG][ERROR][objMana]::__concat | Attempt to concatenate Object objMana with non-alphanumberic data type.",2);
      return "";
    end --endif
    return tostring(self.baseMax)..other..tostring(self.absMax)..other..tostring(self.remaining)..other..tostring(self.experience.level)..other..tostring(self.experience.amt);
  end, --endfunction __concat
  __unm=function(self)
    local newMana=self.new();
    newMana.baseMax=0;
    newMana.absMax=0;
    newMana.remaining=0;
    newMana.experience.level=0;
    newMana.experience.amt=0;
    return newMana;
  end, --endfunction __unm
  __add=function(self,other)
    local newMana = self.new();
    if (getmetatable(other).__index._TYPE == getmetatable(self).__index._TYPE) then
      newMana.baseMax=self.baseMax+other.baseMax;
      newMana.absMax=self.absMax+other.absMax;
      newMana.remaining=self.remaining+other.remaining;
      newMana.experience.level=self.experience.level+other.experience.level;
      newMana.experience.amt=self.experience.amt+other.experience.amt;
    elseif (tonumber(other)) then
      newMana.baseMax=self.baseMax+other;
      newMana.absMax=self.absMax+other;
      newMana.remaining=self.remaining+other;
      newMana.experience.level=self.experience.level+other;
      newMana.experience.amt=self.experience.amt+other;
    elseif (type(other)=="table") then -- {baseMax,absMax,remaining,{experience.level,experience.amt}}
      newMana.baseMax=self.baseMax+other[1]; -- OR {baseMax,absMax,remaining,experience.level,experience.amt};
      newMana.absMax=self.absMax+other[2];
      newMana.remaining=self.remaining+other[3];
      newMana.experience.level=self.experience.level+(other[4][1] or other[4]);
      newMana.experience.amt=self.experience.amt+(other[4][2] or other[5]);
    end
    return newMana;
  end, --endfunction __add
  __sub=function(self,other)
    local newMana = self.new();
    if (getmetatable(other).__index._TYPE == getmetatable(self).__index._TYPE) then
      newMana.baseMax=self.baseMax-other.baseMax;
      newMana.absMax=self.absMax-other.absMax;
      newMana.remaining=self.remaining-other.remaining;
      newMana.experience.level=self.experience.level-other.experience.level;
      newMana.experience.amt=self.experience.amt-other.experience.amt;
    elseif (tonumber(other)) then
      newMana.baseMax=self.baseMax-other;
      newMana.absMax=self.absMax-other;
      newMana.remaining=self.remaining-other;
      newMana.experience.level=self.experience.level-other;
      newMana.experience.amt=self.experience.amt-other;
    elseif (type(other)=="table") then -- {baseMax,absMax,remaining,{experience.level,experience.amt}}
      newMana.baseMax=self.baseMax-other[1]; -- OR {baseMax,absMax,remaining,experience.level,experience.amt};
      newMana.absMax=self.absMax-other[2];
      newMana.remaining=self.remaining-other[3];
      newMana.experience.level=self.experience.level-(other[4][1] or other[4]);
      newMana.experience.amt=self.experience.amt-(other[4][2] or other[5]);
    end
    return newMana;
  end, --endfunction __sub
  __mul=function(self,other)
    local newMana = self.new();
    if (getmetatable(other).__index._TYPE == getmetatable(self).__index._TYPE) then
      newMana.baseMax=self.baseMax*other.baseMax;
      newMana.absMax=self.absMax*other.absMax;
      newMana.remaining=self.remaining*other.remaining;
      newMana.experience.level=self.experience.level*other.experience.level;
      newMana.experience.amt=self.experience.amt*other.experience.amt;
    elseif (tonumber(other)) then
      newMana.baseMax=self.baseMax*other;
      newMana.absMax=self.absMax*other;
      newMana.remaining=self.remaining*other;
      newMana.experience.level=self.experience.level*other;
      newMana.experience.amt=self.experience.amt*other;
    elseif (type(other)=="table") then -- {baseMax,absMax,remaining,{experience.level,experience.amt}}
      newMana.baseMax=self.baseMax*other[1]; -- OR {baseMax,absMax,remaining,experience.level,experience.amt};
      newMana.absMax=self.absMax*other[2];
      newMana.remaining=self.remaining*other[3];
      newMana.experience.level=self.experience.level*(other[4][1] or other[4]);
      newMana.experience.amt=self.experience.amt*(other[4][2] or other[5]);
    end
    return newMana;
  end, --endfunction __mul
  __div=function(self,other)
    local newMana = self.new();
    if (getmetatable(other).__index._TYPE == getmetatable(self).__index._TYPE) then
      newMana.baseMax=self.baseMax/other.baseMax;
      newMana.absMax=self.absMax/other.absMax;
      newMana.remaining=self.remaining/other.remaining;
      newMana.experience.level=self.experience.level/other.experience.level;
      newMana.experience.amt=self.experience.amt/other.experience.amt;
    elseif (tonumber(other)) then
      newMana.baseMax=self.baseMax/other;
      newMana.absMax=self.absMax/other;
      newMana.remaining=self.remaining/other;
      newMana.experience.level=self.experience.level/other;
      newMana.experience.amt=self.experience.amt/other;
    elseif (type(other)=="table") then -- {baseMax,absMax,remaining,{experience.level,experience.amt}}
      newMana.baseMax=self.baseMax/other[1]; -- OR {baseMax,absMax,remaining,experience.level,experience.amt};
      newMana.absMax=self.absMax/other[2];
      newMana.remaining=self.remaining/other[3];
      newMana.experience.level=self.experience.level/(other[4][1] or other[4]);
      newMana.experience.amt=self.experience.amt/(other[4][2] or other[5]);
    end
    return newMana;
  end, --ednfunction __div
  __mod=function(self,other)
    local newMana = self.new();
    if (getmetatable(other).__index._TYPE == getmetatable(self).__index._TYPE) then
      newMana.baseMax=self.baseMax%other.baseMax;
      newMana.absMax=self.absMax%other.absMax;
      newMana.remaining=self.remaining%other.remaining;
      newMana.experience.level=self.experience.level%other.experience.level;
      newMana.experience.amt=self.experience.amt%other.experience.amt;
    elseif (tonumber(other)) then
      newMana.baseMax=self.baseMax%other;
      newMana.absMax=self.absMax%other;
      newMana.remaining=self.remaining%other;
      newMana.experience.level=self.experience.level%other;
      newMana.experience.amt=self.experience.amt%other;
    elseif (type(other)=="table") then -- {baseMax,absMax,remaining,{experience.level,experience.amt}}
      newMana.baseMax=self.baseMax%other[1]; -- OR {baseMax,absMax,remaining,experience.level,experience.amt};
      newMana.absMax=self.absMax%other[2];
      newMana.remaining=self.remaining%other[3];
      newMana.experience.level=self.experience.level%(other[4][1] or other[4]);
      newMana.experience.amt=self.experience.amt%(other[4][2] or other[5]);
    end
    return newMana;
  end, --endfunction __mod
  __pow=function(self,other)
    local newMana = self.new();
    if (getmetatable(other).__index._TYPE == getmetatable(self).__index._TYPE) then
      newMana.baseMax=self.baseMax^other.baseMax;
      newMana.absMax=self.absMax^other.absMax;
      newMana.remaining=self.remaining^other.remaining;
      newMana.experience.level=self.experience.level^other.experience.level;
      newMana.experience.amt=self.experience.amt^other.experience.amt;
    elseif (tonumber(other)) then
      newMana.baseMax=self.baseMax^other;
      newMana.absMax=self.absMax^other;
      newMana.remaining=self.remaining^other;
      newMana.experience.level=self.experience.level^other;
      newMana.experience.amt=self.experience.amt^other;
    elseif (type(other)=="table") then -- {baseMax,absMax,remaining,{experience.level,experience.amt}}
      newMana.baseMax=self.baseMax^other[1]; -- OR {baseMax,absMax,remaining,experience.level,experience.amt};
      newMana.absMax=self.absMax^other[2];
      newMana.remaining=self.remaining^other[3];
      newMana.experience.level=self.experience.level^(other[4][1] or other[4]);
      newMana.experience.amt=self.experience.amt^(other[4][2] or other[5]);
    end
    return newMana;
  end, --endfunction __pow
  __tostring=function(self)
    local str = "{";
    for i,v in pairs(self) do
      str=str..",["..i.."]="..v..(not self[i+1] and "}" or "");
      if not (str[i+1]) then break; end
    end
    return str;
  end, --endfunction __tostring
  __eq=function(self,other)
    return (self.baseMax==other.baseMax) and 
    (self.absMax==other.absMax) and
    (self.remaining==other.remaining) and
    (self.experience.level==other.experience.level) and
    (self.experience.amt==other.experience.amt);
  end, --endfunction __eq
  __lt=function(self,other)
    local percentage=0;
    if (self.baseMax<other.baseMax) then
      percentage=percentage+(1/5);
    end
    if (self.absMax<other.absMax) then
      percentage=percentage+(1/5);
    end
    if (self.remaining<other.remaining) then
      percentage=percentage+(1/5);
    end
    if (self.experience.level<other.experience.level) then
      percentage=percentage+(1/5);
    end
    if (self.experience.amt<other.experience.amt) then
      percentage=percentage+(1/5);
    end
    return percentage>=1/2;
  end, --endfunction __lt
  __le=function(self,other)
    return (self<other) or (self==other);
  end --endfunction __le
};

function mana:new(plr,bMx,aMx,r,xpl,xpa)
  print("[DEBUG][objMana]::new|Creating new Object mana for player "..API.getPlayer(plr).Name..".");
  return plr~=nil and setmetatable({player=API.getPlayer(plr).Name,baseMax=bMx or 100,absMax=aMx or 1000,remaining=r or bMx,experience={level=xpl or 0,amt=xpa or 0}},mt) or die("[DEBUG][ERROR][objMana]::new|Attempt to call `new' with no player parameter.",2);
end

function mana:addExperience(amt)
  if ((not not amt) or (amt<0)) then
    error("[DEBUG][ERROR][objMana]::addExperience | `amt' is less than 0 (zero) or nil.",2);
  end --endif
  self.experience.amt = self.experience.amt + amt;
end --endfunction mana.addExperience

function mana:calcXPForLvlUp()
  return 100*1.25^(self.experience.level+1); -- f(x)=a*b^t/tau
end --endfunction calcXPForLvlUp

function mana:recalculateLevel()
  if (self.experience.amt >= self.calcXPForLvlUP()) then
    self.experience.level = self.experience.level + 1;
    self.recalculateLevel();
  end -- endif
  -- putting `self.recalculateLevel()' here would cause an infinite loop.
end --endfunction mana.recalculateLevel

function mana:useMana(amt) -- amt is rounded up when lowering `mana.remaining' and rounded down when calclating xp gain.
  if ((not not amt) or (amt<0)) then
    error("[DEBUG][ERROR][objMana]::useMana | `amt' isless than 0 (zero) or nil.",2);
  end --endif
  self.experience.amt = self.experience.amt + (math.floor(amt) / 100);
  self.remaining = self.remaining - math.ceil(amt);
  self.recalculateLevel();
  return self.remaining,self.experience.amt;
end --endfunction mana.useMana

function mana:replenishMana(amt)
  if ((not not amt) or (amt<0)) then
    error("[DEBUG][ERROR][objMana]::replenishMana | `amt' is less than 0 (zero) or nil.",2);
  end --endif
  if (self.remaining+amt>self.absMax) then
    self.remaining=self.absMax;
  else
    self.remaining=self.remaining+amt;
  end --endif
end -- endfunction mana.replensishMana

return mana;