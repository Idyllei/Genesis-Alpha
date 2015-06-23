-- status.moon

import del from ObjectFuncs

PAPI = require 'P_API'

enum = (names) ->
  __enumId = 0
  t = {}
  for i, k in pairs names
    if type(k) == 'table'
      t[i] = enum k
    t[k] = __enumId
    __enumId += 1
  t



create_ = assert(LoadLibrary 'RbxUtil').Create
Create = (Name, Properties) ->
  with Instance.new Name
    for i, v in pairs Properties
      [i] = v


class U_Status
  E = enum {'error', 'speed', 'poison', 'fatigue', 'confusion', 'hallucinate'}

  setup = (player) =>
    player = PAPI.GetPlayer player
    assert player
    del player.Character.Humanoid\FindFirstChild('Status')
    Create('Configuration') {
      Parent: player.Character.Humanoid
      Name: 'Status'
      Create('StringValue'){Name:' Status'}
      Create('IntValue'){Name: 'Length'}
      Create('BoolValue'){Name: 'ForceStop'}
      Create('BindableFunction'){Name: 'Callback'}
    }

  run: (player) =>
    player = PAPI.GetPlayer player
    warn 'U_Status\\run: Attempt to run status of unknown player `#{player}`'
    for i = 0, player.Character.Status.Length.Value -- IntValue
      if player.Character.Humanoid.Status.ForceStop.Value
        break
      player.Character.Humanoid.Status.Callback!
      wait 1

  stop: (player) =>
    player = PAPI.GetPlayer player
    assert player, 'U_Status\\stop: Attempt to stop status of unknown player ${player}'
    player.Character.Humanoid.Status.ForceStop.Value = true
    wait 1
    player.Character.Humanoid.Status.ForceStop.Value  = false


  setStatus: (player, stat, len) =>
    player = PAPI.GetPlayer player
    assert s, 'U_Status\\setStatus: Attempt to set unknown status value: `#{stat}`'
    assert player, 'U_Status\\setStatus: Attempt to set status of unknown player `#{player}`'
    player.Character.Humanoid.Status.Status.Value = stat
    player.Character.Humanoid.Status.Length.Value = len or math.huge

  getStatus: (player) =>
    player = PAPI\GetPlayer player
    assert player, 'Status\\getStatu: Attempt to retreive the status of unknown player `${player}`'
    player.Character.Humanoid.Status.Status.Value

return U_Status