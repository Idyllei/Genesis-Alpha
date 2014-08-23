-- // Inventory.moon
API = require "API"
S_DATA_STORE = game\GetService "DataStoreService"
Sys = require "Sys"
NotImplemented = Sys.NotImplemented
INVENTORIES = S_DATA_STORE\GetDataStore "Inventories"
class Inventory

	new: (plrName) ->
		t = {
			Owner: plrName
			INVENTORY:{}
			addItem: (item) =>
				if item.__type == Item
					insert self,item.Name,item
				else
					pcall error, "[DEBUG][ERROR][Inventory+Items]|Attempt to `addItem` a non-Item value to Inventory.",2
			getItem: (i) =>
				if (type i) == "string"
					@INVENTORY[i]
				elseif (type i) == "number"
					for _,v in pairs @INVENTORY
						if v.Id == i
							v
				elseif (type i) == "table"
					for _,v in pairs @INVENTORY
						if v == i
							v
			getItems: =>
				@INVENTORY
		}
		INVENTORIES[plrName] = setmetatable t,{
			__index: t
			__newindex: (i,v) =>
				if (v.__parent == Item) --- TODO: Make all items subclasses of `Item`
					self[i] = v
				else
					pcall error, "[DEBUG][ERROR][INVENTORY]|Attempt to set invalid value (non-Item) to index: `" .. i .. "`",2
			__metatable: =>
				rawget self, "__index"
		}
		INVENTORIES[plrName]
	getInventory: (plr) ->
		INVENTORIES[API.getUserId plr]
	setInventory: (plr,t) ->
		INVENTORIES[API.getUserId plr] = t or @new (API.getPlayer plr).Name
	loadInventory: (plr) ->
		(S_DATA_STORE\GetDataStore "Inventory")\GetAsync (API.getUserId plr) or @new (API.getPlayer plr).Name
	saveInventory: (plr) ->
		(S_DATA_STORE\GetDataStore "Inventory")\SetAsync (API.getUserId plr).Name, @getInventory plr