-- Items.moon

-- 
--	super { -- Recipe
--		[1]:{ -- Top
--			[1]: "", -- Top-Left
--			[2]: "", -- Top-Middle
--			[3]: ""  -- Top-Right
--		},
--		[2]:{ -- Middle
--			[1]: "", -- Mid-Left
--			[2]: "", -- Center
--			[3]: ""  -- Mid-Right
--		},
--		[3]:{ -- Bottom
--			[1]: "", -- Bottom-Left
--			[2]: "", -- Bottom-Middle
--			[3]: ""  -- Bottom-Right
--		}
--	},{ -- Properties
--		Name: ""
--  	Id: 0x4df8f86e
--  	Owner: nil
--  	callback: =>
--  		nil
--  	use: =>
--  		nil
--  },{ -- Metatable
--  	__call: =>
--  		@use!
--  }

Math = require "Math"
LOG = require "stdlog"
S_DATA_STORE = game\GetService "DataStoreService"
ATTACKED_EVENT = game.ReplicatedStorage\FindFirstChild "AttackedEvent"
PSEUDO_CHAR = with Instance.new "Model"
	.Name = "NULL_PLAYER"

pack = (...) ->
	{...}

GetMass = (oModel) ->
	nMass = 0
	for _,v in pairs oModel
		if v\IsA "BasePart"
			nMass += v\GetMass!
	nMass

-- Torso
with Instance.new "Part"
	.Name = "HumanoidRootPart"
	.Size = Vector3.new 2,2,1
	.Parent = PSEUDO_CHAR
-- LeftLeg
with Instance.new "Part"
	.Name = "LeftLeg"
	.Size = Vector3.new 1,2,1
	.Parent = PSEUDO_CHAR
-- RightLeg
with Instance.new "Part"
	.Name = "RightLeg"
	.Size = Vector3.new 1,2,1
	.Parent = PSEUDO_CHAR
-- LeftArm
with Instance.new "Part"
	.Name = "LeftArm"
	.Size = Vector3.new 1,2,1
	.Parent = PSEUDO_CHAR
-- Right Arm
with Instance.new "Part"
	.Name - "RightArm"
	.Size = Vector3.new 1,2,1
	.Parent = PSEUDO_CHAR
-- Head
with Instance.new "Part"
	.Name = "Head"
	.Size = Vector3.new 2,2,2
	.Parent = PSEUDO_CHAR
-- Head.SpecialMesh
with Instance.new "SpecialMesh"
	.MeshType = "Head"
	.Parent = PSEUDO_CHAR.Head

NULL_PLAYER = {
	Name: "NULL_PLAYER"
	userId: -1
	MembershipType: 0
	AccountAge: 1e9 -- 1,000,000,000 (1 Thousand Million or 1 Billion)
	Character: PSEUDO_CHAR
}

class Item
	-- getItemByType_Id(Type t_, Id id) : template<? extends Item>
	getItemByType_Id: (t_,id) ->
		if Items.Types[t_]
			for v in Items[Items.Types[t_]]
				if v.getId! == id
					return v
		return Items.Item
	-- newItemByType_Name(Type t_, String name) : template<? extends Item>
	newItemByType_Name: (t_, name) ->
		if Items.Types[t_]
			return Items[Items.Types[t_]][name]!
		return Items.Item!
	-- new() : Item item
	new: =>
		@__ITEM: setmetatable {
			Name: "<<<ROOT>>>"
			Id: 0x4df8f86e -- Møøn | Items.Id["<<<ROOT>>>"]
			Owner: nil
			Type: 0
			callback: =>
				return
			use: =>
				@callback!
			getId: =>
				@Id
			getName: =>
				@Name
			getOwner: =>
				@Owner
			getOwnerId: =>
				@Owner.userId
		},{
			__call: =>
				@use!
		}
		@__ITEM

-- Item.ItemERROR
-- ItemError() : ItemERROR item
class ItemERROR extends Item
	-- new() : ItemERROR
	new: =>
		@__ITEM: setmetatable {
			-- `<!>` is my favorite way to show an error;
			-- In Perl, `$!` is the variable that hold error messagers
			-- And `<>` is the `$_` (or environment) scalar variable,
			-- So by combining them, I use it to refer to an ERROR item.
			Name: "<!>"
			-- `<!>` in Hex
			Id: 0x3C213E -- 246,291 OR `<!>`
			-- No one should EVER own one of these,
			-- they are for debugging purposes ONLY
			Owner: nil
			-- If something attempts to use this item,
			-- we will log it as an error
			callback: =>
				LOG\logError "Attempt to call `ItemERROR` class", nil, "Items.ItemERROR"
			use: =>
				@callback!
		},{
			-- __call() -> use() -> callback() : nil
			__call: =>
				@use!
		}
		@__ITEM

-- Item.Craftable
-- Craftable(Table Recipe, Table Properties, Table Metatable)
class Craftable extends Item
	addCraftingRecipe: (tRecipe, item) ->
		Items.Recipes[tRecipe[1][1]] or= {}
		Items.Recipes[tRecipe[1][1]][tRecipe[1][2]] or= {}
		Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]] or= {}
		Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]] or= {}
		Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]] or= {}
		Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]] or= {}
		Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]] or= {}
		Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]] or= {}
		Items.Recipes[tRecipe[1][1]][tRecipe[1][2]][tRecipe[1][3]][tRecipe[2][1]][tRecipe[2][2]][tRecipe[2][3]][tRecipe[3][1]][tRecipe[3][2]][tRecipe[3][3]] or= setmetatable tItem, tMT
		
	-- new(Table tRecipe, Table tProperties, Table tMT) : CratableItem
	new: (tRecipe,tProperties,tMT) =>
		-- we don't have to set the metatable, yet...
		@__ITEM: super!
		-- Set the recipe
		for _,v1 in ipairs tRecipe
			if (not Items.Id[v1]) or ((type v1) ~= "string")
				LOG\logError "Encountered item with invalid Recipe", nil, "Items.#{tProperties.Name}"
				break
		-- If it had an error, let it be, otherwise set it to what it 
		-- should be
		-- Set the properties of the item
		for kProp,vVal in pairs tProperties
			pcall -> self[kProp] = vVal
		-- Now we can set the metatable of the item.
		@__ITEM

-- Item.NonCraftable
-- NonCraftable(Table Properties, Table Metatable)
class NonCraftable extends Item
	new: (tProperties,tMT) =>
		-- We don't have to set the metatable, yet...
		@__ITEM = super!
		-- Since it is not craftable, then we don't have to set it's place in the
		-- Recipe directory
		-- Set the item's properties.
		for kProp,vVal in pairs tProperties
			pcall -> @__ITEM[kProp] = vVal
		-- Now we can set the metatable of the item. (And return it)
		setmetatable @__ITEM, tMT



Items = {

	Item: Item, -- Item()
	Craftable: Craftable, -- Craftable(Table Recipe, Table Properties, Table Metatable)
	NonCraftable: NonCraftable, -- NonCraftable(Table Properties, Table Metatable)
	Types:{
		[0]: "CORE",
		[1]: "RawMaterials", -- Raw Materials used in crafting other items
		[2]: "Blocks", -- Blocks
		[3]: "Charms", -- Used for various purposes
		[4]: "Tablets", -- Used to craft Runes
		[5]: "Runes", -- Enchantment Runes
		[6]: "Tomes", -- (Books)
		[7]: "Keys" -- To advance to next room (mazes)
	}
	Recipes: {NONE:{NONE:{NONE:{NONE:{NONE:{NONE:{NONE:{NONE:{NONE:ItemERROR!}}}}}}}},
	Id:{
		ROOT      : 0x4df8f86e -- Møøn
		NONE      : 0 -- Used as placeholders in `NonCraftable` Items
		ItemERROR : 0x3C213E -- <!>
		"<!>"     : 0x3C213E -- <!>
	},
	RawMaterials:{
		Id:{
			ERROR: -1
		}
	}
	Charms:{
		Id:{
			ERROR: -1
			Scarab_Charm: 1
			Djed_Charm: 2
			Isis_Curse_Charm: 3
			Amethyst_Luck_Amulet: 4
			Sun_Stone_Utere_Fexix_Luck_Charm: 5
			Wedjat_Eye_Amulet: 6
			Evil_Eye_Amulet: 7
			Lapis_Lazuli_Amulet: 8
			Isis_Knot: 9
			Plummet_amulet: 10
			Sesen_Charm: 11
			Double_Plume_Feathers_Amulet: 12
			Shen_Amulet: 13
			Ieb_Charm: 14
			Imenet_Charm: 15
			Ka_Charm: 16
			Menhed_Charm: 17
			Nebu_Charm: 18
			Pet_Charm: 19
			Ushabtis_Amulet: 20
			Was_Amulet: 21
			Menta_Rune: 22
			Winged_Solar_Disk: 23
			Amenta_Rune: 24
			Maat_Rune: 25
			Naos_Tablet: 26
			Palm_Branch_Charm: 27
			Sa_Amulet: 28
			Sekhem_Rune: 29
			Sema_Rune: 30
		}

		class Scarab_Charm extends Craftable -- Allows the beholder to keep items after death
			new: (plrName) =>
				super {
					[1]:{ -- Top
						[1]:"Gold_Ingot", -- Top-Left   -- |
						[2]:"Honey_Pot", -- Top-Middle  -- |> Binding
						[3]:"Gold_Ingot"  -- Top-Right  -- |
					},
					[2]:{ -- Middle
						[1]:"Ankh", -- Mid-Left
						[2]:"Sun_Stone", -- Center
						[3]:"Ushabtis_Amulet"  -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]:"Gold_Ingot", -- Bottom-Left   -- |
						[2]:"Honey_Pot", -- Bottom-Middle  -- |> Binding
						[3]:"Gold_Ingot"  -- Bottom-Right  -- |
					}
				},{
					Name: "Scarab_Charm"
					Id: Items.Charms.Id["Scarab_Charm"]
					Owner: API.getPlayer plrName
					Used: false
					callback: =>
						if not Used
							@Used = true
							@Owner.Character.Humanoid.Died\connect ->
								@Used = false
								(S_DATA_STORE\GetDataStore "Inventory")\SetAsync (@Owner.Name),API.GetInventory (@Owner.Name)
					use: => @callback!
				},{
					__call: =>
						@callback!
				}

		class Djed_Charm extends Craftable -- Gives the owner resistance to fall damage
			new: (plrName) =>
				super {
					[1]:{ -- Top
						[1]:"Clay_Block", -- Top-Left    -- |
						[2]:"Slime_Ball", -- Top-Middle  -- |> Binding
						[3]:"Clay_Block"  -- Top-Right   -- |
					},
					[2]:{ -- Middle
						[1]:"Soft_Cloud",    -- Mid-Left
						[2]:"Diamond_Boots", -- Center
						[3]:"Soft_Cloud"     -- Mid-Right
					},
					[3]:{
						[1]:"Clay_Block", -- Bottom-Left   -- |
						[2]:"Slime_Ball", -- Bottom-Middle -- |> Binding
						[3]:"Clay_Block"  -- Bottom-Right  -- |
					}
				},{
					Name: "Djed_Charm"
					Id: Items.Charms.Id["Djed_Charm"]
					Owner: API.getPlayer plrName
					callback: ->
						nil
					use: => @callback!
				},{
					__call: (...) =>
						LOG\logInfo "Djed_Charm called with arguements:\t#{unpack {...}}", nil, "Items"
						return ...
				}

		class Isis_Curse_Charm extends NonCraftable -- NOT Craftable
			new: (plrName) =>
				super {
					Name: "Isis_Curse_Charm"
					Id: Items.Charms.Id["Isis_Curse_Charm"]
					Owner: API.getPlayer plrName
					callback: (player) =>
						player = API.getPlayer player
						if player
							with (script.Parent\FindFirstChild "Isis_Curse")\Clone!
								.Parent = player.Character.Humanoid
								.Disabled = false
					use: (player) =>
						@callback player
				},{
					__call: (player,...) =>
						LOG\logInfo "Isis_Curse_Charm called on player #{(API.getPlayer player).Name}"
						@use player
				}

		class Amethyst_Luck_Amulet extends Craftable -- Increases chances at high tier bounty
			new: (plrName)=>
				super {
					[1]:{ -- Top
						[1]:"Stick", -- Top-Left
						[2]:"String", -- Top-Middle
						[3]:"Stick"  -- Top-Right
					},
					[2]:{ -- Middle
						[1]:"Honey_Pot", -- Mid-Left
						[2]:"Amethyst", -- Center
						[3]:"Thyme" -- Middle-Right
					},
					[3]:{ -- Bottom
						[1]:"Stick", -- Bottom-Left
						[2]:"String", -- Bottom-Middle
						[3]:"Stick"  -- Bottom-Right
					}
				},{
					Name: "Amethyst_Luck_Amulet"
					Id: Items.Charms.Id["Amethyst_Luck_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						if @Owner
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync @Owner.Name, (val) ->
								val * (math.random 1.25,1.625)
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync @Owner.Name
							@Destroy!
					use: =>
						@callback!
				},{
					__call: =>
						LOG\logInfo "Amethyst_Luck_Amulet called on player #{@Owner.Name}", nil, "Items"
						@use!
				}

		class Sun_Stone_Utere_Fexix_Luck_Charm extends Craftable
			new: (plrName) =>
				super {
					[1]:{ -- Top
						[1]:"Stick", -- Top-Left    -- |
						[2]:"String", -- Top-Middle -- |> Binding
						[3]:"Stick" -- Top-Right    -- |
					},
					[2]:{ -- Middle
						[1]:"Imenet_Charm", -- Mid-Left -- Helas owner at dawn
						[2]:"Sun_Stone", -- Center
						[3]:"Ka_Charm" -- Mid-Right -- Heals owner at dusk
					},
					[3]:{ -- Bottom
						[1]:"Stick", -- Bottom-Left    -- |
						[2]:"String", -- Bottom-Middle -- |> Binding
						[3]:"Stick" -- Bottom-Right    -- |
					}
				},{
					Name: "Sun_Stone_Utere_Fexix_Luck_Charm"
					Id: Items.Charms.Id["Sun_Stone_Utere_Fexix_Luck_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						if @Owner
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync @Owner.Name, (val) ->
								val * (Math.random 1.5,1.875)
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync @Owner.Name
					use: =>
						@callback!
				},{
					__call: =>
						LOG\logInfo "Sun_Stone_Utere_Fexix_Luck_Charm called on player #{@Owner.Name}", nil, "Items"
						@use!
				}

		class Wedjat_Eye_Amulet extends Craftable -- Provides a health buff and higher health
			new: (plrName) =>
				super {
					[1]:{ -- Top
						[1]:"String", -- Top-Left
						[2]:"NONE", -- Top-Middle
						[3]:"String" -- Top-Right
					},
					[2]:{ -- Middle
						[1]:"Glowing_Water", -- Mid-Left
						[2]:"Heart", -- Center
						[3]:"Pixie_Dust" -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]:"NONE", -- Bottom-Left
						[2]:"NONE", -- Bottom-Middle
						[3]:"NONE" -- Bottom-Right
					}
				},{
					Name: "Wedjat_Eye_Amulet"
					Id: Items.Charms.Id["Wedjat_Eye_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						if @Owner
							Owner.Character.Humanoid.MaxHealth *= 1.25
							Owner.Character.Humanoid.Health = Owner.Character.Humanoid.MaxHealth
					use: =>
						@callback!
				},{
					__call: =>
						LOG\logInfo "Wedjat_Eye_Amulet called on player #{@Owner.Name}", nil, "Items.charms.Wedjat_Eye_Amulet"
						@use!
				}

		class Evil_Eye_Amulet extends Craftable -- Give attacker bad luck
			new: (plrName) =>
				super {
					[1]:{ -- Top
						[1]: "Gold_Ingot",     -- Top-Left
						[2]: "Electrum_Ingot", -- Top-Middle
						[3]: "Silver_Ingot"    -- Top-Right
					},
					[2]:{ -- Middle
						[1]: "Sun_Stone",  -- Mid-Left
						[2]: "Wraith_Eye", -- Center
						[3]: "Moon_Stone"  -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]: "Gold_Ingot",     -- Bottom-Left
						[2]: "Electrum_Ingot", -- Bottom-Middle
						[3]: "Silver_Ingot"    -- Bottom-Right
					}
				},{
					Name: "Evil_Eye_Amulet"
					Id: Items.Charms.Id["Evil_Eye_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						if @Owner
							thread ->
								(game.ReplicatedStorage\FindFirstChild "AttackedEvent").OnServerEvent\connect (attacker,recipient,damage,weaponType) ->
									if recipient
										attacker.Character.Humanoid\TakeDamage damage*.1 -- give them 10% of the damage they delt to us
										(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync attacker.Name, (val) ->
											val * (Math.random .7,.85)
										(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync attacker.Name
					use: =>
						@callback!
				},{
					__call: =>
						@use!
				}

		class Lapis_Lazuli_Amulet extends Craftable -- Brings *slight* luck to the user
			new: (plrName) =>
				super {
					[1]:{ -- Top
						[1]: "Gold_Dust", -- Top-Left
						[2]: "Sun_Stone", -- Top-Middle
						[3]: "Gold_Dust"  -- Top-Right
					},
					[2]:{ -- Middle
						[1]: "Blue_Wool",   -- Mid-Left
						[2]: "Lapis_Block", -- Center
						[3]: "Blue_Wool"    -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]: "Gold_Dust",  -- Bottom-Left
						[2]: "Moon_Stone", -- Bottom-Middle
						[3]: "Gold_Dust"   -- Bottom-Right
					}
				},{
					Name: "Lapis_Lazuli_Amulet"
					Id: Items.Charms.Id["Lapis_Lazuli_Amulet"]
					Owner: API.getPlayer plrName
					maxUses: 5
					nUses: 0
					callback: =>
						if @Owner
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\UpdateAsync @Owner.Name, (val) ->
								val * (Math.random 1.2,1.51)
							(S_DATA_STORE\GetDataStore "Bounty_Luck")\GetAsync @Owner.Name
					use: =>
						-- add to the use counter
						@nUses += 1
						-- call the callback
						@callback!
						-- check to make sure we haven't used it too much
						if nUses >= @maxUses
							@Destroy!
				},{
					__call: =>
						LOG\logInfo "Lapis_Lazuli_Amulet called on player #{@Owner.Name}", nil, "Item.Craftable.Lapis_Lazuli_Amulet"
						@use!
				}

		class Isis_Knot extends Craftable -- Protects wearer from direct attacks (bare hand/type `0` tool)
			new: (plrName) =>
				super { -- Recipe
					[1]:{ -- Top
						[1]: "NONE",   -- Top-Left
						[2]: "String", -- Top-Middle
						[3]: "NONE"    -- top-Left
					},
					[2]:{ -- Middle
						[1]: "String", -- Mid-Left
						[2]: "Clay",   -- Center
						[3]: "String"  -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]: "NONE",   -- Bottom-Left
						[2]: "String", -- Bottom-Middle
						[3]: "NONE"    -- Bottom-Right
					}
				},{ -- Properties
					Name: "Isis_Knot"
					Id: Items.Charms.Id["Isis_Knot"]
					Owner: API.getPlayer plrName
					callback: =>
						(game.ReplicatedStorage\FindFirstChild "AttackedEvent").OnServerEvent\connect (attacker,recipient,damage,weaponType) ->
							-- someone else (besides themself) attack the owner:
							if (attacker ~= @Owner) and (recipient == @Owner)
								if weaponType ~= 0
									@Owner.Character\TakeDamage damage
								else
									-- do a very slight damage to opponent to show them who is boss >:3
									ATTACKED_EVENT.InvokeServer NULL_PLAYER, attacker, 1e-9, -1
									-- NULL_PLAYER is the default pseudo-player to use when the server is acting as a player
									-- 1e-9 is the damage to do (almost none) to show the injury screen.
									-- -1 is the weaponType to use to show that it is the server (versus the client) doing the damage here
					use: =>
						@callback!
				},{ -- Metatable
					__call: =>
						@use!
				}
				thread ->
					values = pack (game.ReplicatedStorage\FindFirstChild "AttackedEvent").OnServerEvent\wait!
					while ((INVENTORY.getInventory plrName).hasItem "Isis_Knot") and values
						attacker,recipient,damage,type_ = unpack values
						if recipient == API.getPlayer plrName
							if type_ ~= "direct"
								recipient.Humanoid\TakeDamage damage
							else
								LOG\logInfo "Isis_Knot Blocked damage from direct attack on #{recipient.Name}", nil, "Item.NonCraftable.Isis_Knot"
						values = pack (game.ReplicatedStorage\FindFirstChild "AttackedEvent").OnServerEvent\wait!

		class Plummet_Amulet extends Craftable -- Prevents SOME fall damage to owner
			new: (plrName) =>
				super { -- Recipe
					[1]:{ -- Top
						[1]: "Feather",   -- Top-Left
						[2]: "Soft_Sand", -- Top-Middle
						[3]: "Feather"    -- Top-Right
					},
					[2]:{ -- Middle
						[1]: "NONE",        -- Mid-Left
						[2]: "Slime_Block", -- Center
						[3]: "NONE"         -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]: "Enchanted_Book__Feather_Falling", -- Bottom-Left
						[2]: "Quicksilver",                     -- Bottom-Middle
						[3]: "Diamond_Boots"                    -- Bottom-Right
					}
				},{ -- Properties
					Name: "Plummet_Amulet"
					Id: Items.Charms.Id["Plummet_Amulet"]
					Owner: API.getPlayer plrName
					callback: =>
						-- Clone script.Impact to the player's character
						if @Owner.Character\FindFirstChild "Impact"
							-- Allready exists
							(@Owner.Character\FindFirstChild "Impact").Disabled = false
						else
							-- Does not exists yet
							with (script\FindFirstChild "Impact")\Clone!
								.Parent = @Owner.Character
								.Disabled = false
					use: => @callback!
					unequip: =>
						(@Owner.Character\FindFirstChild "Impact").Disabled = true
				},{ -- Metatable
					__call: =>
						@use!
				}

		class Sesen_Charm extends Craftable -- Saves the owner's inventory (up to 10 times)
			new: (plrName) =>
				super { -- Recipe
					[1]: { -- Top
						[1]: "Stick",    -- Top-Left
						[2]: "Diamond",  -- Top-Middle
						[3]: "Stick"     -- Top-Right
					},
					[2]:{ -- Middle
						[1]: "Leather",  -- Mid-Left
						[2]: "Diamond",  -- Center
						[3]: "Leather"   -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]: "Stick",   -- Bottom-Left
						[2]: "Diamond", -- Bottom-Middle
						[3]: "Stick"    -- Bottom-Right
					}
				},{ -- Properties
					Name: "Sesen_Charm"
					Id: Items.Charms.Id["Sesen_Charm"]
					Owner: API.getPlayer plrName
					maxUses: 10
					nUses: 0
					callback: =>
						(S_DATA_STORE\GetDataStore "Inventory")\SetAsync (@Owner.Name),API.GetInventory (@Owner.Name)
						@Owner\LoadCharacter!
						-- Loading of the player's Inventory will be handled in the main script
					use: =>
						-- Auto-called on Humanoid.Death event
						nUses += 1
						@callback!
						if @nUses >= @maxUses
							@Destroy!
					Destroy: =>
						-- call Pseudo-Destroy on child elements
						for v in self
							v = nil
						-- `Destroy` self
						self = nil
				},{ -- Metatable
					__call: =>
						@use!
				}

		class Double_Plume_Feathers_Amulet extends Craftable -- Provides Owner 2x Jump Height
			new: (plrName) =>
				super: {
					[1]:{ -- Top
						[1]: "Feather",     -- Top-Left
						[2]: "Aer_Essence", -- Top-Middle
						[3]: "Feather"      -- Top-right
					},
					[2]:{ -- Middle
						[1]: "Solid_Aer", -- Mid-Left
						[2]: "Sapphire",  -- Center
						[3]: "Solid_Aer"  -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]: "Quartz_Block", -- Bottom-Left
						[2]: "Silver_Block", -- Bottom-Middle
						[3]: "Quartz_Block"  -- Bottom-Right
					}
				},{
					Name: "Double_Plume_Feathers_Amulet"
					Id: Items.Charms.Id["Double_Plume_Feathers_Amulet"]
					Owner: API.getPlayer plrName
					callback: ->
						nil
					use: =>
						@callback!
				},{
					__call: =>
						@use!
				}
				if API.getPlayer plrName
					with Instance.new "BodyForce" 
						.force = (Vector3.new 0,192.6,0) * (GetMass (API.getPlayer plrName).Character)
						.Parent = (API.getPlayer plrName).Character.Humanoid.Torso
					thread ->
						game.player.PlayerAdded\connect (plr) ->
							plr.CharacterAdded\connect (chr) ->
								with Instance.new "BodyForce"
									force = (Vector3.new 0,192.6,0) * (GetMass chr)
									Parent = chr.Character.Humanoid.Torso

		class Shen_Amulet extends Craftable -- Gives 2.5x Health to @Owner
			new: (plrName) =>
				super {
					[1]:{ -- Top
						[1]: "Blood_Vial",   -- Top-Left
						[2]: "Copper_Ingot", -- Top-Middle
						[3]: "Blood_Vial"    -- Top-Right
					},
					[2]:{ -- Middle
						[1]: "Healing_Tablet", -- Mid-Left
						[2]: "Herb_Sack",      -- Center
						[3]: "Healing_Tablet"  -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]: "Skull", -- Bottom-Left
						[2]: "Heart", -- Bottom-Middle
						[3]: "Skull"  -- Bottom-Right
					}
				},{
					Name: "Shen_Amulet"
					Id: Items.Charms.Id["Shen_Amulet"]
					Owner: API.getPlayer plrName
					callback: ->
						nil
					use: =>
						@callback!
				},{
					__call: =>
						@use!
				}
				with (@Owner.Character or (API.getPlayer plrName).Character)
					.MaxHealth *= 2.5
					.Health = .MaxHealth
				thread ->
					game.Players.PlayerAdded\connect (plr) ->
						if plr.Name == @Owner.Name
							plr.CharacterAdded\connect (chr) ->
								with chr
									.MaxHealth *= 2.5
									.Health = .MaxHealth

		class Ieb_Charm extends Item -- Gives owner Health Regen Buff
			new: (plrName) =>
				setmetatable {
					Name: "Ieb_Charm"
					Id: Items.Charms.Id["Ieb_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						nil
					use: => @callback!
				},{
					__call: =>
						@use!
				}
				thread ->
					chr = API.getPlayer plrName
					if chr
						while chr and wait 1.25
							chr.Humanoid.Health = Math.min chr.Humanoid.MaxHealth,(chr.Humanoid.Health + chr.Humanoid.Health * Math.random .1,.5525)
				thread ->
					game.Players.PlayerAdded\connect (plr) ->
						if plr.Name == plrName
							plr.CharacterAdded\connect ->
								thread (chr) ->
									if not not chr
										while chr and wait 1.25
											chr.Humanoid.Health = Math.min chr.Humanoid.MaxHealth,(chr.Humanoid.Health + chr.Humanoid.Health * Math.random .1,.5525)

		class Imenet_Charm extends Item -- Heals owner @ Dusk
			new: (plrName) =>
				setmetatable {
					Name: "Imenet_Charm"
					Id: Items.Charms.Id["Imenet_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						-- Make sure that the Charm has an owner
						if @Owner
							-- Make a separate thread for the charm's Callback
							Spawn ->
								-- Dusk is @ 20:00 (8:00 PM)
								while LIGHTING\GetMinutesAfterMidnight! < 1140
									-- Wait 20 seconds before checking again
									wait 20
								-- wait 1/8 of a second between loops
								while wait 0.125
									-- Short-dot syntax for brievity
									with @Owner.Character.Humanoid
										-- Use a random lerp to calculate the halt to give
										.Health = .Health + (.Health - .MaxHealth) * math.abs (math.random! - math.random!)
						else
							LOG\logWarn "@Owner is nil, cannot call `callback` properly.",nil, "Item.NonCraftable.Imenet_Charm"
					use: =>
						@callback!
				}, {
					__call: =>
						use!
				}

		class Ka_Charm extends Craftable -- Heals owner @ Dawn
			new: (plrName) =>
				super {
					[1]:{ -- Top
						[1]:"NONE", -- Top-Left
						[2]:"Knowledge_Fragment", -- Top-Middle
						[3]:"NONE" -- Top-Right
					},
					[2]:{ -- Middle
						[1]:"Clay", -- Mid-Left
						[2]:"Blank_Tablet", -- Center
						[3]:"Clay" -- Mid-Right
					},
					[3]:{ -- Bottom
						[1]:"Scribe_Set", -- Bottom-Left
						[2]:"Golden_Ring", -- Bottom-Middle
						[3]:"Ink_Vial" -- Bottom-Right
					}
				},{
					Name: "Ka_Charm"
					Id: Items.Charms.Id["Ka_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						-- Make sure that the charm has an Owner
						if @Owner
							-- Make a separate thread for the charm's Callback
							Spawn ->
								-- Dawn is @ 06:00 (6:00 AM)
								while LIGHTING\GetMinutesAfterMidnight! < 360
									-- Wait 20 seconds before checking again
									wait 20
								-- wait 1/8 of a second between loops
								while wait 0.125
									-- Short-dot syntax for brievity
										with @Owner.Character.Humanoid
											-- Use a random Lerp to calculate the health to give
											.Health = .Health + (.Health - .MaxHealth) * math.abs (math.random! - math.random!)
						else
							LOG\logWarn "@Owner is nil, cannot call `callback` properly.",nil, "Item.Craftable.Ka_Charm"
					use: =>
						@callback!
				},{
					__call: =>
						@use!
				}
		class Menhed_Charm extends Craftable -- Allows owner to craft tablets at less cost
			new: (plrName) =>
				@__ITEM = super { -- tRecipe
					[1]: { -- Top
						[1]: "Moonstone_Dust", -- Top-Left
						[2]: "Electrum_Ingot", -- Top-Middle
						[3]: "Sunstone_Dust"   -- Top-right
					},
					[2]:{ -- Middle
						[1]: "Blank_Tablet", -- Mid-Left
						[2]: "Scribe_Set",   -- Center
						[3]: "Blank_Tablet", -- Mid-right
					},
					[3]:{ -- Bottom
						[1]: "Gold_Block", 	   -- Bottom-Left
						[2]: "Electrum_Block", -- Bottom-Middle
						[3]: "Silver_Block"    -- Bottom-Right
					}
				},{ -- tProperties
					Name: "Menhed_Charm"
					Id: Items.charms.Id["Menhed_Charm"]
					Owner: API.getPlayer plrName
					callback: =>
						(S_DATA_STORE\GetDataStore "Stats")\UpdateAsync @Owner, (t) ->
							{
								nPlays: t.nPlays,
								StandingPosition: t.StandingPosition, -- Where they were standing
								TabletCostLess: t.TabletCostLess + ((x/2.718281828)^-.6183358898)^(0.36787944123356733855191706781332),
								Humanoid:{
									MaxHealth: t.Humanoid.MaxHealth,
									Health: t.Humanoid.Health,
									WalkSpeed: t.Humanoid.WalkSpeed,
								},
								-- // the Player's Bank Account BONUSES
								Bank:{
									-- // Reward the player for playing by giving 10% more interest
									Interest: t.Bank.Interest
								},
								Inventory:{
									-- // Reward the player for playing by giving more uses per-item
									-- // nUses Subtractive Number (increases *slightly* per-visit)
									-- 
									nUsesLess: t.Inventory.nUsesLess
								}
							}
					@use: =>
						@callback!
				},{ -- tMT
					__call: =>
						@use!
				}

	}
}