-- game_evolution.moon

--Things that should be run on the server side:
--	- Map manipulation (open doors, rotate staircases, destroy 
--	walls, roll boulders)
--	- Player manipulation (kill players, change outfits, 
--	teleport players, launch players)
--	- Game logic (begin a round of the game, update scores, 
--	decide game winner)
--	- Game events (fire missiles, create tornado, release the 
--	Kraken)
--
--Things that should be run on the client side:
--	- GUIs
--	- Sounds
--	- Animations

CONFIG = require "towns.config"
API = require "API"
PLAYERS = game.Players
HEARTBEAT = (game\GetService "RunService").Heartbeat -- Used instead of wait()
DATA_STORE = game\GetService "DataStoreService"

PLAYERS.PlayerAdded\connect (plr) ->
	-- No checking needed, ROBLOX does that for us
	if (DATA_STORE\GetDataStore "Bank")\GetAsync plr.Name
		-- This player has played before, get their save data
		playerData = (DATA_Store\GetAsync "Stats")\GetAsync plr.Name
		-- Spawn them where they were last:
		plr\LoadCharacter!
		plr.Character.Humanoid.Torso.CFrame = playerData.StandingPositionCFrame
		with plr.PlayerGui\FindFirstChild "Loading"
			for i = 0,1,wait!
				.Transparency = i
