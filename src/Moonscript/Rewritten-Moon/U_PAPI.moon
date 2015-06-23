-- U_PAPI.moon

PLAYERS = game.Players

from TypeFuncs import ^  -- Import Proper
from ObjectFuncs import del
from Util import Require


class U_PAPI  -- Utility Singleton
  _INVENTORY = Require 'U_INVENTORY' unless _INVENTORY or _G.U_PAPI -- TODO: Reqrite `Inventory.moon`
  _PLAYER_SETTINGS = Require 'U_PLAYER_SETTINGS' unless _PLAYER_SETTINGS or _G.U_PAPI -- TODO: Rewrite `PlayerSettings.moon`
  _CONFIG = Require 'TOWNS.config' unless _CONFIG or _G.U_PAPI

  GetPlayer: ->
    {plr.Name: plr for plr in PLAYERS\GetPlayers!}

  GetPlayerId: (plr) =>  -- Single Player
    @GetPlayer(plr).userId
 
  GetPlayerIds: ->  -- ALL Players
    {plr.userId for plr in *PLAYERS\GetPlayers!}

  GetPlayerHealth: (...) =>
    {@GetPlayer(plr).Character.Humanoid.Health for plr in *{...}}

  GetPlayerStatus: (...) =>
    {@GetPlayer(plr).Character.Humanoid.Status.Value for plr in *{...}}

  SetPlayerStatus: (stat, ...) =>
    for plr in *{...}
      @GetPlayer(plr).Character\FindFirstChild('Humanoid').Status.Value = stat

  GetUserId: (...) =>
    {@GetPlayer(plr).Name: @GetPlayer(plr).usrId for plr in *{...}}

  AnimateDeath: (player) =>
    for limb in @GetPlayer(player).Character\GetChildren!
      pcall ((limb) -> limb.Transparency = 1), limb
    if @_PLAYER_SETTINGS[@GetPlayer(player).Name].SaveInventory
      @_INVENTORY.SavePlayerInventory @GetPlayer(player).Name
    @GetPlayer(player).PlayerGui\FindFirstChild('RespawnButton').MouseButton1Click\connect ->
      @RespawnPlayer @GetPlayer player

  LoadPlayerSkin: (player) =>
    if player = @GetPlayer player
      player.Character\FindFirstChild('Shirt').ShirtTemplate "http://www.roblox.com/asset/?id=" .. game\GetService("DataStoreService")\GetGlobalDataStore!\GetAsync(player.Name).."$ShirtTemplate"
      player.Character\FindFirstChild('Pants').PantsTemplate "http://www.roblox.com/asset/?id=" .. game\GetService("DataStoreService")\GetGlobalDataStore!\GetAsync(player.Name).."$PantsTemplate"

  Op: (player) =>
    if player = @GetPlayer player
      @_GLOBAL_SETTINGS.OPS\insert player.Name -- TODO: Change case of settings keys

  DeOp: (player) =>
    if player = @GetPlayer player
      playerName = player.Name
      pos = nil
      for iplr in pairs @GetPlayers!
        if v == playerName
          por = i
          break
      @_GLOBAL_SETTINGS.OPS\remove pos

  Kick: (player) =>
    if player = @GetPlayer player
      playerName = player.Name
      if @_CONFIG.gentleKick == 1
        @SaveCheckpoint player
      player\Kick!
      thread ->
        now = tick!
        kickCallback = PLAYERS.PlayerAdded\connect (p) ->
          if @GetPlayer(p).Name == playerName
            p\Kick!
        if tick! > (now + @_CONFIG.KickTime)
          kickCallback\disconnect!

  Ban: (plr) =>
    if player = @GetPlayer player
      @Kick player
      @_GLOBAL_SETTINGS.Banned\insert player.Name

  ChangeSetting: (setting, value) =>
    if type(value) == type(@_GLOBAL_SETTINGS[setting]) or not Bool(@_GLOBAL_SETTINGS[setting])
      @_GLOBAL_SETTINGS[setting] = value

  GetPlayerPosition: (player) =>
    if player = @GetPlayer player
      player.Character\FindFirstChild('HumanoidRootPart').Position

  SetCameraNormal: (player) =>
    player = @GetPlayer player
    del {item for item in player.Character\GetChildren! if item.Name\find '^Camera'}
    with Service('ReplicatedStorage')\FindFirstChild('CameraFixedLocal')\Clone!
      .Parent = player.Character
      .Disabled = false
  
  SetameraFollow: (player) =>
    player = @GetPlayer player
    del {item for item in player.Character\GetChildren! if item.Name\find '^Camera'}
    with Service('ReplicatedStorage')\FindFirstChild('CameraFixedLocal')\Clone!
      .Parent = player.Character
      .Disabled = false

  SetCameraPosition: (player, vec3) =>
    player = @GetPlayer player
    del {item for item in player.Character\GetChildren! if item.Name\find '^Camera'}
    with Service('ReplicatedStorage')\FindFirstChild('CameraFixedLocal')\Clone!
      .Parent = player.Character
      .Position.Value = vec3
      .Disabled = false
