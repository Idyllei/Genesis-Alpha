local CONFIG = {
  spawnpoints = { },
  spawnPoint = (function()
    do
      local _with_0 = Instance.new("SpawnPoint")
      _with_0.Position = Vector3.new((unpack(spawnpoints[math.random(1, #spawnpoints)])))
      _with_0.Transparency = 1
      _with_0.Anchored = true
      _with_0.CanCollide = false
      return _with_0
    end
  end)(),
  volcano = {
    MaxNPC = 10,
    Extents = 12,
    Concentration = 2.1,
    Buildings = 7,
    SpawnDelta = 1.0208333,
    Bartering = {
      MagicDelta = .1,
      FoodDelta = .25,
      MedicalDelta = .25,
      CharmsDelta = .2,
      CompanionsDelta = .15,
      BlackMagicCharmsDelta = 0.0
    }
  },
  void = {
    MaxNPC = 15,
    Extents = 10,
    Concentration = 0.25,
    Buildings = 12,
    SpawnDelta = .3,
    Bartering = {
      MagicDelta = .025,
      BlackMagicDelta = .1,
      FoodDelta = .1,
      MedicalDelta = .075,
      CharmsDelta = .25,
      CompanionsDelta = .45,
      BlackMagicCharmsDelta = 0.0
    }
  },
  aether = {
    MaxNPC = 25,
    Extents = 30,
    Concentration = 1.125,
    Buildings = 25,
    SpawnDelta = 9.375,
    Bartering = {
      MagicDelta = .25,
      BlackMagicDelta = .05,
      FoodDelta = .1405,
      MedicalDelta = .2,
      charmsDelta = .35,
      CompanionsDelta = .15,
      BlackMagicCharmsDelta = 0.0
    }
  },
  chthonic = {
    MaxNPC = 30,
    Extents = 10,
    Concentration = .225,
    Buildings = 124,
    SpawnDelta = 2.79,
    Bartering = {
      MagicDelta = .05,
      BlackMagicDelta = .25,
      FoodDelta = .075,
      MedicalDelta = .075,
      CharmsDelta = .05,
      CompanionsDelta = .25,
      BlackMagicCharmsDelta = .25
    }
  },
  palace = {
    MaxNPC = 80,
    Extents = 20,
    Concentration = 3.25,
    Buildings = 75,
    SpawnDelta = 6.09375,
    Bartering = {
      MagicDelta = .125,
      BlackMagicDelta = .075,
      FoodDelta = .15,
      MedicalDelta = .25,
      CharmsDelta = .1,
      CompanionsDelta = .2,
      BlackMagicCharmsDelta = .1
    }
  }
}
