-- main.moon

-- /* Argument Type Notation:
--  * Abstract Class: Abstract_Class<Name>
--  * Class: Class<Name, sub[SuperclassName] | inherit[ParentName]>
--  * Enumeration: Enum<Name, minEnumValue, maxEnumValue>
--  * Function: Function<Args..., Return<Type...>>
--  * Integer: Int[minValue, maxValue] | Int[minValue] | Int[,maxValue]
--  * String: String[minLength, maxLength] | String[length]
--  * Table: Table<IndexType, ValueType> | Table<Tuple> | Table<> | Table<...> | Table<undef>
--  */

-- /* Variable Notation:
--  * S_    : Game Service
--  * M_	: Module
--  * E_	: Event
--  * chr   : Character
--  * plr   : Player
--  * n     : Number (Usually b10)
--  * s     : String
--  * t     : Table
--  * k     : Key/Index of a Table data value
--  * v     : Value of a Table data value
--  * o     : Object
--  * ROBLOX Lua Data Types:
--  * v3    : Vector3
--  * cf    : CFrame
--  * r3    : Region3
--  * u2    : UDim2
--  * v3i16 : Vector3Int16
--  * r3i16 : Region3Int16
--  * u2i16 : UDim2Int16
--  * CUSTOM Data Types
--  * h     : Hash (w/o mixed-NULL characters)
--  * hb    : Hash (Binary, w/ mixed-NULL characters)
--  * c     : Clock/Timer
--  * <ALL_CAPITALS_AND_UNDERSCORES> : Constant (Do not edit)
--  * <NONE OF THE ABOVE> : Most likely a 'Module'
--  */

-- Moonscript OOP Doc:
-- class.__inherited(...) : Fired when a class inherits from `class`
-- class.__class : the type of the class `class`
-- class.__base : Modifying this value modifies all other classes that 
-- inherit from the same base
-- class.__parent : hold the class of the parent that `class` inherits
-- @@ : Indexes `self.__class`
  -- ex: @@hello!
  --     self.__class.hello()





--------------------------
-- Set up Nevermore Engine
--------------------------
ReplicatedStorage     = game\GetService "ReplicatedStorage"

Nevermore             = require ReplicatedStorage\WaitForChild "NevermoreEngine"
LoadCustomLibrary     = NevermoreEngine.LoadLibrary

qSystems              = LoadCustomLibrary "qSystems"

qSystems\Import getfenv 0

-- getPlayersWithinRadius(PlayerList, Position, Radius),
-- getPlayersWithinBlastRadius(PlayerList, Position, Radius, IgnoreList, 
--     IgnoreInvisible, IgnoreCollisions, TerrainCellsAreCubes),
-- getPlayersWithValidCharacters(), 

qPlayer				  = LoadCustomLibrary "qPlayer"

Type				  = LoadCustomLibrary "Type"

-- tagHumanoid(Humanoid, Killer), getKiller(Character)
RawCharacter	      = LoadCustomLibrary "RawCharacter"

Character             = LoadCustomLibrary "Character"

-- isTagged(Player, TagName, TagId), tag(Player, TagName),
-- untag(Player, TagName), 
PlayerTagTracker      = LoadCustomLibrary("PlayerTagTracker")

-- new(), makeMaid()
-- Maid[key] = (function)            Adds a task to perform when cleaning up.
-- Maid[key] = (event connection)    Manages an event connection. Anything that isn't a function is assumed to be this.
-- Maid[key] = nil                   Removes a named task. If the task is an event, it is disconnected.
--
-- Maid:GiveTask(task)               Same as above, but uses an incremented number as a key.
-- Maid:DoCleaning()                 Disconnects all managed events and performs all clean-up tasks.

EventMaid		      = LoadCustomLibrary "Maid"

-- GetLevelFromExperience(Experience), 
-- GetExperienceForNextLevel(CurrentExperience)
ExperienceCalculator  = LoadCustomLibrary "ExperienceCalculator"

qPlayer\Import getfenv 0

Type\Import getfenv 0

RawCharacter\Import (getfenv 0), "Raw"

Character\Import (getfenv 0), "Safe"

EventMaid\Import getfenv 0

ExperienceCalculator\Import getfenv 0
-----------------------------
-- End Nevermore Engine Setup
-----------------------------

(require "bank").setup!
math = require "Math"
NPCPlayer = require "NPCPlayer"
mana = require "objMana"
status = require "status"
pathfinder = require "pathfinder"
townConfig = require "townConfig"
API = require "API"
INVENTORY = require "Inventory"
Logger = require "stdlog"
RunTests = require "runTests"

-- // Game Services
S_RUN = game\GetService "RunService"
S_DEBRIS = game\GetService "DebrisService"
S_SCRIPT_CONTEXT = game\GetService "ScriptContext"
S_SCRIPT_DEBUGGER = game\GetService "ScriptDebugger"
S_DATA_STORE = game\GetService "DataStoreService"
S_PLAYERS = game.Players

-- Event Maids (used by the game):
CoreMaids = {
	PlayerAdded: EventMaid.makeMaid!
	PlayerRemoving: EventMaid.makeMaid!
	CharacterAdded: EventMaid.makeMaid!
	Died: EventMaid.makeMaid!
	WatchAdded: EventMaid.makeMaid!
	WatchRemoved: EventMaid.makeMaid!
	Resuming: EventMaid.makeMaid!
	BreakpointAdded: EventMaid.makeMaid!
	BreakpointRemoved: EventMaid.makeMaid!
	EncounteredBreak: EventMaid.makeMaid!
	Changed: EventMaid.makeMaid!
	Error: EventMaid.makeMaid!
	Custom: {
		Attack: EventMaid.makeMaid!
	}
}

log2 = (n) ->
	_n = 2
	x = 1
	if (_n < n)
		x += 1
		_n += _n
		while not (_n >= n)
			x += 1
			_n += _n
	elseif (_n >= n)
		if (n == 1)
			0
		else
			nil
	if (_n > n)
		x-1
	else
		x

round = (number, places) ->
	mult = 10^(point or 0)
	(math.floor number * mult + 0.5) / mult

RUNTEST (getfenv 0), "round", {
	ARG:{
		{100.255, 2},
		{0.0625, 6},
		{math.pi, 3},
		{math.huge, 1},
		{-math.huge, 1},
		{1/3, 3}
	},
	EXPECTED:{
		100.26,
		0.062500,
		3.15,
		math.huge,
		-math.huge,
		0.333
	}
}

xround = (number, places) ->
	x = if (number*places<0) then -0.5 else 0.5
	(math.modf number*places+x)[1] / places

RUNTEST (getfenv 0), "xround", {
	ARG:{
		{100.255, 2},
		{12345.678,-2},
		{0.0625, 6},
		{math.pi, 3},
		{math.pi, -3},
		{math.huge, 1},
		{math.huge, -1},
		{-math.huge, 1},
		{1/3, 3}
	},
	EXPECTED:{
		100.26,
		12345.68,
		0.062500,
		3.15,
		3.15,
		math.huge,
		math.huge,
		-math.huge,
		0.333
	}
}

-- r3i = -> (...) -- (r3i v1.x,v1.y,v1.z,v2.x,v2.y,v2.z)
--    Region3int16.new (Vector3int16.new select 1,...),(Vector3int16.new select 4,...)

-- /*
--  * Heartbeat wait
--  * Waits for a default of 1/30 of a second, as per the default wait time
--  * of the normal `wait` function.
--  * Returns: Time elapsed and the current DistributedGameTime, and the
--  * change in the DistributedGameTime during execution (or LACK of execution)
--  */
hwait = (nS=1/30) ->
	nT = tick!
	nDGT = Workspace.DistributedGameTime
	while (tick! - nT) < nS
		S_RUN.Heartbeat\wait!
	return tick! - nT, Workspace.DistributedGameTime, Workspace.DistributedGameTime - nDGT

-- /*
--  * RenderStepped `wait`
--  * Waits for a default of 1/60 of a second, as per 1/2 the default wait time
--  * of the normal `wait` function.
--  * Returns: Time elapsed and the current DistributedGameTime, and the
--  * change in the DistributedGameTime during execution (or LACK of execution)
--  */
rwait = (nS=1/60) ->
	nT = tick!
	nDGT = Workspace.DistributedGameTime
	while (tick! - nT) < nS
		S_RUN.RenderStepped\wait!
	return tick! - nT, Workspace.DistributedGameTime, Workspace.DistributedGameTime - nDGT

-- /*
--  * Stepped `wait`
--  * Waits for `nS` seconds. Waits for a default of 1 second, or 30x the
--  * default `wait` time.
--  * Returns: Time elapsed and the current DistributedGameTime, and the
--  * change in the DistributedGameTime during execution (or LACK of execution)
--  */

swait = (nS=1) ->
	nT = tick!
	nDGT = Workspace.DistributedGameTime
	nW = nil
	while (tick!-nT) < nS
		S_RUN.Stepped\wait!
	return tick! - nt, Workspace.DistributedGameTime, Workspace.DistributedGameTime - nDGT

-- /*
--  * Stepped Millisecond `wait`
--  * Waits for `nM` milliseconds or a default of 33 milliseconds.
--  * Returns: Time elapsed and the current DistributedGameTime, and the
--  * change in the DistributedGameTime during execution (or LACK of execution)
--  */
waitms = (nM=33) ->
	nT = tick!
	nDGT = Workspace.DistributedGameTime
	while (tick!-nT)<(nMs*1000)
		S_RUN.RenderStepped\wait!
	return tick!-nT,Workspace.DistributedGameTime, Workspace.DistributedGameTime - nDGT

--   //////////////////
--  ////// MAIN //////
-- //////////////////

--	  //////////
--	 // MAIN //
--	//////////

-- /* 
--  * Main portion of the script.
--  * controls many of the coordination abilites of the script.
--  */
-- public static void main(String[] args) noexcept
main = ->
	return


-- //////////////////
-- ///////SETUP//////
-- //////////////////


--	  //////////
--	 // BANK //
--	//////////

-- /*
--  * Sets the player's bank account when they join the game.
--  * If they haven't played before, creates a new account for them.
--  */
CoreMaids["PlayerAdded"]["Bank"] = S_PLAYERS.PlayerAdded\connect (plr) ->
	-- // Shouldn't need API.getPlayer(Player) for `plr`, as it always will be
	-- // if the player already has an account:
	if acc = (S_DATA_STORE\GetDataStore "Bank")\GetAsync plr.Name
		-- // Make sure to load it
		accounts[plr.Name] = acc
	else
		bank.setAccount plr

--	   /////////////
--	  // STAMINA //
--	 /////////////

-- /*
--  * Functions as stamina for the player. A crude, but effective,
--  * implementation.
--  *
--  * TODO: Make this a non-hacky method. Preferably on that uses global
--  * variables.
--  */
CoreMaids["PlayerAdded"]["Stamina"] = S_PLAYERS.PlayerAdded\connect (plr) ->
	plr.CharacterAdded\connect (chr) ->
		Spawn ->
			nStamina = 100
			bRunning = false

			-- make a new thread to change their WalkSpeed
			Spawn ->
				-- check stamina every 1/2 second
				while wait .5
					-- if they have very little stamina
					if nStamina < 10
						-- make them slow
						chr.Humanoid.WalkSpeed = round (chr.Humanoid.WalkSpeed*(nStamina/100)*(1-chr.HumanoidWalkSpeedMultiplier.Value)), 2
					else
						-- speed them up
						chr.Humanoid.WalkSpeed = round (chr.Humanoid.WalkSpeed*(nStamina/100)*(1+chr.HumanoidWalkSpeedMultiplier.Value)), 2
			
			-- do a rapid loop
			-- /* TODO: Should we change it to `wait .25` to allow other
			--  *  processes to run more often, & for longer?
			--  */
			while wait!
				-- make sure stamina is NOT less than 1
				nStamina = (nStamina >= 1) and nStamina or 1
				-- if they start or stop, invert `running`
				if chr.Humanoid.Running\wait!
					bRunning = not bRunning
				-- while they have stamina, reduce what is remaining ONLY if they are faster than def. WS
				if bRunning and chr.Humanoid.Running\wait! >= 16
					while bRunning and wait 1
						nStamina -= 7.5
				-- if they are slower (not def. WS)
				elseif chr.Humanoid.Running\wait! < 16
					-- replinish it slowly
					while wait .5
						nStamina += 5

--	  ///////////////
--	 // INVENTORY //
--	////////////////

-- /*
--  * Loads the player's inventory and saves it in the 
--  * `INVENTORY.__PLAYER_INVENTORIES` table for later
--  * reference.
--  *
--  * NOTE: Also deducts the `nUsesLess` from the damage of each item, as 
--  * a reward for playing the game at least once.
--  */

CoreMaids["PlayerAdded"]["Inventory"] = S_PLAYERS.PlayerAdded\connect (plr) ->
	-- // Load the player's inventory so that we msay proceed
	plrInventory = INVENTORY.loadInventory plr.Name
	-- // iterate through each item and reduce its `nUses`
	for i,v in plrInventory.getItems!
		-- // only change `nUses` if it is there, otherwise we will error
		if v.nUses
			plrInventory[i].nUses -= math.floor ((S_DATA_STORE\GetDataStore "Stats")\GetAsync plr.Name).Inventory.nUsesLess

--   ///////////////
--  //// DEATH ////
-- ///////////////

-- /*
--  * Saves the player's stats on death and updates their kills, deaths,
--  * and KDR.
--  *
--  * NOTE: Uses NevermoreEngine's `RawCharacter` module
--  */
CoreMaids["PlayerAdded"]["Death"] = S_PLAYERS.PlayerAdded\connect (plr) ->
	CoreMaids["CharacterAdded"]["Death"] = plr.CharacterAdded\connect (chr) ->
		CoreMaids["Died"]["Death"] = chr.Humanoid.Died\connect ->
			-- // Save the player's inventory if they have a `Scarab_Charm`
			if (INVENTORY.getInventory plr).hasItem "Scarab_Charm"
				(S_DATA_STORE\GetDataStore "Inventory")\SetAsync plr.Name,INVENTORY.getInventory plr
			-- // update the player's KDR (+1 death)
			(S_DATA_STORE\GetDataStore "KDR")\UpdateAsync plr.Name,(kdr) ->
				{
					nKills: kdr.kills
					nDeaths: kdr.deaths + 1
					kdr: kdr.kills / (kdr.deaths + 1)
				}
			-- // update the attacker's KDR (+1 Kill)
			(S_DATA_STORE\GetDataStore "KDR")\UpdateAsync (RawCharacter.getKiller plr.Character.Humanoid), (kdr) ->
				{
					nKills: kdr.kills + 1
					nDeaths: kdr.deaths
					kdr: (kdr.kills + 1) / kdr.deaths
				}

--	  //////////
--	 // SAVE //
--	//////////

-- /*
--  * Saves the player's stats when they leave the game.
--  * These stats include: Bank Account, Inventory, last standing position,
--  * last MaxHealth, Health, WalkSpeed, their Bank Account interest 
--  * (incrmented), and the # of uses to deduct from their item limits next
--  * time the player joins the game.
--  */

CoreMaids["PlayerRemoving"]["Save"] = S_PLAYERS.PlayerRemoving\connect (plr) ->
	-- // Save the player's Bank Account for the next time they join the game
	(S_DATA_STORE\GetDataStore "Bank")\SetAsync plr.Name,accounts[plr.Name]
	-- // Save the player's inventory for the next time they join the game
	(S_DATA_STORE\GetDataStore "Inventory")\SetAsync plr.Name,INVENTORY.getInventory plr
	-- // Save the player's POSITIVE stats for the next time they join the game
	(S_DATA_STORE\GetDataStore "Stats")\SetAsync plr.Name,{
		nPlays: ((S_DATA_STORE\GetDataStore "Stats")\GetAsync plr.Name).nPlays + 1
		StandingPosition: plr.Character.Humanoid.Torso.Position -- Where they were standing
		Humanoid:{
			MaxHealth: plr.Character.Humanoid.MaxHealth
			Health: plr.Character.Humanoid.Health
			WalkSpeed: math.max plr.Character.Humanoid.WalkSpeed, 10
		}
		-- // the Player's Bank Account BONUSES
		Bank:{
			-- // Reward the player for playing by giving 10% more interest
			Interest: accounts[plr.Name].JointAccount.Interest + .1
		}
		Inventory:{
			-- // Reward the player for playing by giving more uses per-item
			-- // nUses Subtractive Number (increases *slightly* per-visit)
			-- 
			nUsesLess: ((S_DATA_STORE\GetDataStore "Stats")\GetAsync plr.Name).Inventory.nUsesLess + .5 + (math.floor 1.61833588985^(((S_DATA_STORE\GetDataStore "Stats")\GetAsync plr.Name).nPlays/1.6183358898)) - 1
		}
	}

--   //////////
--  // LUCK //
-- //////////

-- /*
--  * Rewards luck to players if they visit on a lucky number.
--  * Creates 2 messages, one for ther player to see, and 
--  * one for all players to see (5s after the local message)
--  */
CoreMaids["PlayerAdded"]["Luck"] = S_PLAYERS.PlayerAdded\connect (plr) ->
	(S_DATA_STORE\GetDataStore "Plays")\UpdateAsync "Plays", (nVal)->
		-- Check to see if `nVal` is a power of `10`, which is a lucky #
		-- in the game.
		if (math.log10 nVal+1) % 1 == 0
			oMsg = with Instance.new "Message"
				.Text = "Thank you for being the #{nVal+1} visitor! You have been awarded with more in-game luck than other players! ~branefreez"
				.Parent = plr.Character
			S_DEBRIS\AddItem oMsg,5

			delay 5, ->
				oWkspcMsg = with Instance.new "Message"
					.Text = "Thank you for the #{nVal+1} visits! ~branefreez"
					.Parent = Workspace
				S_DEBRIS\Additem oWkspcMsg,5
		-- Powers of 2 are VERY lucky numbers. There will be more lucky
		-- numbers during the launch of the game.
		elseif (log2 nVal+1) % 1 == 0
			oMsg = with Instance.new "Message"
				.Text = "Thank you for being the #{nVal+1} visiotr! You have been rewarded with more in-game luck than other players! ~branefreez"
				.Parent = plr.Character
			S_DEBRIS\AddItem oMsg,5

			delay 5, ->
				oWkspcMsg = with Instance.new "Message"
					.Text = "Thank you for the #{nVal+1} visits! ~branefreez"
					.Parent = Workspace
				S_DEBRIS\Additem oWkspcMsg,5
		-- Powers of 1.5 are semi-lucky numbers
		elseif ((math.log10 nVal)/(math.log10 1.5)) % 1 == 0
			oMsg = with Instance.new "Message"
				.Text = "Thank you for being the #{nVal+1} visitor! You have been reqarded more in-game luck than other players! ~branefreez"
				.Parent = plr.Character
			S_DEBRIS\AddItem oMsg,5

			delay 5, ->
				oWkspcMsg = with Instance.new "Message"
					.Text = "Thank you for the #{nVal+1} visits! ~branefreez"
					.Parent = Workspace
				S_DEBRIS\Additem oWkspcMsg,5
		-- increment the nVal to update the DataStore
		nVal+1


--   ///////////////////////
--  ///////DEBUGGING///////
-- ///////////////////////

-- // Logs are in order of least sever to most severe.
CoreMaids["WatchAdded"]["Debugging"] = S_SCRIPT_DEBUGGER.WatchAdded\connect (oWatch) ->
	Logger\logInfo "Watch Added", nil, oWatch\GetFullName!

CoreMaids["WatchRemoved"]["Debugging"] = S_SCRIPT_DEBUGGER.WatchRemoved\connect (oWatch) ->
	Logger\logInfo "Watch Removed", nil, oWatch\GetFullName!

CoreMaids["Resuming"]["Debugging"] = S_SCRIPT_DEBUGGER.Resuming\connect ->
	Logger\logInfo "ScriptDebugger Resumed", nil, "MAIN"

CoreMaids["BreakpointAdded"]["Debugging"] = S_SCRIPT_DEBUGGER.BreakpointAdded\connect (oBreakpoint) ->
	Logger\logDebug "Breakpoint Added", nil, oBreakpoint\GetFullName!

CoreMaids["BreakpointRemoved"]["Debugging"] = S_SCRIPT_DEBUGGER.BreakpointRemoved\connect (oBreakpoint) ->
	Logger\logDebug "Breakpoint Removed", nil, oBreakpoint\GetFullName!

CoreMaids["EncounteredBreak"]["Debugging"] = S_SCRIPT_DEBUGGER.EncounteredBreak\connect (line) ->
	-- [$D:$H:$M:$S] SVRTY:[DEBUG] SRC:[line:Script:CurrentLine]
	--  	$O
	Logger\logDebug "Encountered Break", nil, "#{line}:#{S_SCRIPT_DEBUGGER.Script}:#{S_SCRIPT_DEBUGGER.CurrentLine}"

CoreMaids["Changed"]["Debugging"] = S_SCRIPT_DEBUGGER.Changed\connect (sProperty) ->
	Logger\logDebug "Property `#{sProperty}` of ScriptDebugger Changed", nil, "game:GetService(\"ScriptDebugger\")"

CoreMaids["Error"]["Debugging"] = S_SCRIPT_CONTEXT.Error\connect (sMsg,sTrace,oOrigin) ->
	Logger\logError sMsg, nil, oOrigin\GetFullName!

