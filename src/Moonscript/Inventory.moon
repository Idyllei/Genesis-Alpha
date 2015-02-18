-- // Inventory.moon
import __extends__ from require "__Extends__"
import Item from (require "Items")	-- For some reason, MoonScript acts as if
									-- `*` from `from *` is a variable that is
									-- in our local scope, when it should
									-- actually call `require` on it beforehand
hashids = require "hashids"
hashAlphabet = "ABCDEF1234567890" -- Hex
class Inventory
	@__PLAYER_INVENTORIES: {}

	getInventory: (plrName) =>
		@__PLAYER_INVENTORIES[plrName]

	loadInventory: (plrName) =>
		@__PLAYER_INVENTORIES[plrName] = ((S_DATA_STORE\GetDataStore "Inventories")\GetAsync plrName) or @new plrName
		@__PLAYER_INVENTORIES

	new: (plrName) ->
		@__PLAYER_INVENTORIES[plrName]= setmetatable {},{
			__index: {
				Owner: plrName
				INVENTORY: {}
				--hash: (item,x,y) ->
					--if item.__parent ~= Item
						--pcall error, "[DEBUG][ERROR][INVENTORY]|Attempt to call `hash` on non Item subclass.",2
						--h = "#{item.Name}.#{x}.#{y}"
						--h = ("\0"\rep ((32-h\len!>0) and (32-h\len!) or 0))..h
					--else
						--h = ""
						--index = 1
						--for v in item.Name\gsub "."
							--h ..= string.char (math.floor h\byte! + item.Name\len! - (math.floor 1.618 ^ index)) / ((item.Name\len!-8)/2)
						--h ..= ".#{x}.#{y}"
				contains: (itemName) =>
					for _,v in pairs @INVENTORY
						-- Just in case they pass in an Id, check to make
						-- sure that it doesn't match an Id of an item.
						if (v.Name == itemName) or (v.Id == itemName)
							return true
					false

				-- Alias for `contains`
				containsItem: (itemName) =>
					@contains itemName

				-- Alias for `contains`
				hasItem: (itemName) =>
					@contains itemName
				
				add: (x,itemY,item) =>
					if item -- PAssed 3 Arg
						self[{x,itemY}] = item
					elseif itemY -- Passed {x,y}, item
						self[x] = itemY
					else -- Passed insufficient Arg
						pcall error, "[DEBUG][ERROR][Inventory]|Attempt to call `add` with insufficient parameters.",2
				
				-- Alias for `add`
				addItem: (x,itemY,item) =>
					@add x, itemY, item

				remove: (x,y) =>
					if y -- Passed (x,y) coordinates
						ret = rawget self, {x,y}
						rawset self, {x,y}, nil
						ret
					elseif x -- Passed x = {x,y}
						if (type x) == "table"
							ret = rawget self, x
							rawset self, x, nil
							ret
						else
							pcall error, "[DEBUG][ERROR][Inventory]|Attempt to call `remove` with invalid `x` parameter.",2
							Item!
					else
						pcall error, "[DEBUG][ERROR][Inventory]|Attempt to call `remove` with insufficient parameters.",2
				
				removeItem: (x,y) =>
					@remove x, y

				clear: (id) =>
					if id
						-- clear all items with `ID` of `id`
						for i,v in pairs @INVENTORY
							if v.Id == id
								@remove i
					else
						-- Completely clear the inventory
						for i,v in pairs @INVENTORY
							@remove i

				clean: (id) =>
					@clear id
			}
			-- Inventory[{x,y}] = Item!
			__newindex: (i,v) => -- `i` SHOULD be {x,y}
				if (v.__extends__ Item)
					--@Inventory[@hash v.Name, i.x, i.y] = v
					@Inventory[i] = v
				else
					pcall error, "[DEBUG][ERROR][INVENTORY]|Attempt to set invalid value (non-Item) to index: `#{i}`",2
			
			__metatable: =>
				(getmetatable self).__index
		}

-- Returns the class with static members
return Inventory