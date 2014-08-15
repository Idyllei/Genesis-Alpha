-- // Inventory.moon
from Sys import NotImplemented
class Inventory
	new: (plrName) ->
		t = {
			Owner: plrName
			INVENTORY:{}
		}
		setmetatable t,{
			__index: t
			__newindex: (i,v) =>
				if (v.__parent == Item) --- TODO: Make all items subclasses of `Item`
					self[i] = v
				else
					pcall error, "DEBUG][ERROR][INVENTORY]|Attempt to set invalid value (non-Item) to index: `" .. i .. "`",2
			__metatable: =>
				rawget self, "__index"
		}
