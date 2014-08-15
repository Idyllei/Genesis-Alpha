-- main.moon

(require "bank").setup!
math = require "Math"
NPCPlayer = require "NPCPlayer"
mana = require "objMana"
status = require "status"
pathfinder = require "pathfinder"
townConfig = require "townConfig"
API = require "API"

-- // Game Services
S_RUN = game\GetService "RunService"
S_DEBRIS = game\GetService "DebrisService"
S_SCRIPT_CONTEXT = game\GetService "ScriptContext"
S_SCRIPT_DEBUGGER = game\GetService "ScriptDebugger"
S_DATA_STORE = game\GetService "DataStoreService"
PLAYERS = game.Players

r3i = -> (...) -- (r3i v1.x,v1.y,v1.z,v2.x,v2.y,v2.z)
    Region3int16.new (Vector3int16.new select 1,...),(Vector3int16.new select 4,...)

rwait = (s=1/30) ->
	t = tick!
	while (tick! - t) < s
		S_RUN.Heartbeat\wait!
	return tick! - t, Workspace.DistributedGameTime

hwait = (s=1/60) ->
	t = tick!
	while (tick! - t) < s
		S_RUN.RenderStepped\wait!
	return tick! - t, Workspace.DistributedGameTime

swait = (s) ->
	t = tick!
	while (tick!-t) < s
		S_RUN.Stepped\wait!
	return S_RUN.Stepped\wait!

waitms = (ms) ->
	t = tick!
	while (tick!-t)<(ms*1000)
		S_RUN.RenderStepped\wait!
	return tick!-t,Workspace.DistributedGameTime

--   //////////////////
--  ////// MAIN //////
-- //////////////////

--	  //////////
--	 // MAIN //
--	//////////
main = ->
	return


-- //////////////////
-- ///////SETUP//////
-- //////////////////

--    /////////////////
--	 // FALL-DAMAGE //
--  /////////////////

game.Players.PlayerAdded\connect (plr) ->
			plr.CharacterAdded\connect (chr) ->
				with script.Impact\Clone!
					.Parent = chr.Humanoid
					.Disabled = false

--	  //////////
--	 // BANK //
--	//////////
PLAYERS.PlayerAdded\connect (plr) ->
	-- // if the player already has an account:
	if acc = (S_DATA_STORE\GetDataStore "Bank")\GetAsync (API.getPlayer plr).Name
		-- // Make sure to load it
		accounts[(API.getPlayer plr).Name] = acc
	else
		bank.setAccount plr

--	   /////////////
--	  // STAMINA //
--	 /////////////
PLAYERS.PlayerAdded\connect (plr) ->
	plr.CharacterAdded\connect (chr) ->
		thread ->
			stamina = 100
			running = false

			-- make a new thread to change their WalkSpeed
			thread ->
				-- check stamina every 1/2 second
				while wait .5
					-- if they have very little stamina
					if stamina < 10
						-- make them slow
						chr.Humanoid.WalkSpeed = 8
					else
						chr.Humanoid.WalkSpeed = 16
			
			-- do a rapid loop
			while wait!
				-- make sure stamina is NOT less than 0
				stamina = (stamina > 0) and stamina or 0
				-- if they start or stop, set `running`
				if chr.Humanoid.Running\wait!
					running = not running
				-- while they have stamina, reduce what is remaining
				if running and chr.Humanoid.Running\wait! >= 16
					while running and wait 1
						stamina -= 7.5
				-- if they are slower (not full stamina)
				elseif chr.Humanoid.Running\wait! < 16
					-- replinish it slowly
					while wait .5
						stamina += 5

--	  ///////////////
--	 // INVENTORY //
--	////////////////

PLAYERS.PlayerAdded\connect (plr) ->
	-- // Load the player's inventory so that we msay proceed
	INVENTORY.loadInventory plr.Name
	-- // iterate through each item and reduce its `nUses`
	for v in (INVENTORY.getInventory plr).getItems!
		-- // only change `nUses` if it is there, otherwise we will error
		if v.nUses
			v.nUses -= math.floor ((S_DATA_STORE\GetDataStore "Stats")\GetAsync plr.Name).Inventory.nUsesLess

--   ///////////////
--  //// DEATH ////
-- ///////////////

PLAYERS.PlayerAdded\connect (plr) ->
	plr.CharacterAdded\connect (chr) ->
		chr.Humanoid.Died\connect ->
			-- // Save the player's (whom dies) inventory if they have a `Scarab_Charm`
			if (INVENTORY.getInventory plr).hasItem "Scarab_Charm"
				(S_DATA_STORE\GetDataStore "Inventory")\SetAsync plr.Name,INVENTORY.getInventory plr
			-- // update the player's (whom died) KDR (+1 death)
			(S_DATA_STORE\GetDataStore "KDR")\UpdateAsync plr.Name,(kdr) ->
				{
					kills: kdr.kills
					deaths: kdr.deaths + 1
					kdr: kdr.kills / (kdr.deaths + 1)
				}
			-- // update the attacker's KDR (+1 Kill)
			(S_DATA_STORE\GetDataStore "KDR")\UpdateAsync (plr.Character.Humanoid\FindFirstChild "Attacker").Value, (kdr) ->
				{
					kills: kdr.kills + 1
					deaths: kdr.deaths
					kdr: (kdr.kills + 1) / kdr.deaths
				}

--	  //////////
--	 // SAVE //
--	//////////

PLAYERS.PlayerRemoving\connect (plr) ->
	-- // Save the player's Bank Account for the next time they join the game
	(S_DATA_STORE\GetDataStore "Bank")\SetAsync plr.Name,accounts[plr.Name]
	-- // Save the player's inventory for the next time they join the game
	(S_DATA_STORE\GetDataStore "Inventory")\SetAsync plr.Name,INVENTORY.getInventory plr
	-- // Save the player's POSITIVE stats for the next time they join the game
	(S_DATA_STORE\GetDataStore "Stats")\SetAsync plr.Name,{
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
			nUsesLess: ((S_DATA_STORE\GetDataStore "Stats")\GetAsync plr.Name).Inventory.nUsesLess + .5
		}
	}

PLAYERS.PlayerAdded\connect (plr) ->
	(S_DATA_STORE\GetdataStore "Plays")\UpdateAsync "Plays", (val)->
		if (math.log val,10) == math.floor math.log val,10
			S_DEBRIS\AddItem (Create"Message"{Text:"Thank you for the "..val+1.." visits!!! ~branefreez",Parent:Workspace}),5
		val+1


--   ///////////////////////
--  ///////DEBUGGING///////
-- ///////////////////////

S_SCRIPT_CONTEXT.Error\connect (msg,trace,origin) ->
	print "[ERROR] Origin: `#{origin\GetFullName!}`\n\t[REASON] #{msg}\n\t[FROM] #{trace}"

S_SCRIPT_DEBUGGER.BreakpointAdded\connect (breakpoint) ->
	print "[DEBUG] Breakpoint added: `#{breakpoint\GetFullName!}`"

S_SCRIPT_DEBUGGER.BreakpointRemoved\connect (breakpoint) ->
	print "[DEBUG] Breakpoint removed: `#{breakpoint\GetFullName!}`"

S_SCRIPT_DEBUGGER.EncounteredBreak\connect (line) ->
	print "[DEBUG] Encountered break: #{S_SCRIPT_DEBUGGER.Script}:#{S_SCRIPT_DEBUGGER.CurrentLine}"

S_SCRIPT_DEBUGGER.Resuming\connect ->
	print "[DEBUG] ScriptDebugger Resume()ed"
S_SCRIPT_DEBUGGER.WatchAdded\connect (watch) ->
	print "[DEBUG] Watch Added: #{watch\GetFullName!}"

S_SCRIPT_DEBUGGER.WatchRemoved\connect (watch) ->
	print "[DEBUG] Watch Removed: #{watch\GetFullName!}"

S_SCRIPT_DEBUGGER.Changed\connect (property) ->
	print "[DEBUG] Property `#{property}` of `ScriptDebugger` Changed."

