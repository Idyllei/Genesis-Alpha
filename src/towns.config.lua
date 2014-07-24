local CONFIG={
  volcano={
    MaxNPC=10,
    Extents=12,
    Concentration=2.1,
    Buildings=7,
    SpawnDelta=1.0208333,
    -- if math.random(10) < 1.0208333 then Spawn()
    -- 10.2% Spawn chance
    Bartering={
      MagicDelta=.1, -- 10%           (10)
      FoodDelta=.25, -- 25%           (35)
      MedicalDelta=.25, -- 25%        (60)
      CharmsDelta=.2, -- 20%          (80)
      BlackMagicDelta=.05, -- 5%      (85)
      CompanionsDelta=.15, -- 15%     (100)
      BlackMagicCharmsDelta=0.0 -- 0% (100)
    }
  },
  void={
    MaxNPC=15,
    Extents=10,
    -- Extents: House x and y
    -- Probability=10/(Extents^2/(Buildings*Concentration))
    Concentration=0.25,
    -- Concentration: How many NPCs per building
    -- Should be a value from 0-3, max. 3
    Buildings=12,
    SpawnDelta=.3,
    -- if math.random(10)<.3 then Spawn()
    -- 30% Spawn chance
    Bartering={
      MagicDelta=.025, -- 2.5%        (2.5)
      BlackMagicDelta=.1, -- 10%      (12.5)
      FoodDelta=.1, -- 10%            (22.5)
      MedicalDelta=.075, -- 7.5%      (30)
      CharmsDelta=.25, -- 25%         (55)
      CompanionsDelta=.45, -- 45%     (100) -- It's lonelyin there
      BlackMagicCharmsDelta=0.0 -- 0% (100)
    }
  },
  aether={
    MaxNPC=25,
    Extents=30,
    Concentration=1.125,
    Buildings=25,
    SpawnDelta=9.375,
    --if math.random(10) < 9.375 then Spawn()
    -- 93.75% Spawn chance
    Bartering={
      MagicDelta=.25, -- 25%          (25)
      BlackMagicDelta=0.05, -- 0.05%  (25.05)
      FoodDelta=.1405, -- 14.05%      (30)
      MedicalDelta=.2, -- 20%         (50)
      CharmsDelta=.35, -- 35%         (85)
      CompanionsDelta=.15, -- 15%     (100)
      BlackMagicCharmsDelta=0.0 -- 0% (100)
    }
  },
  chthonic={
    MaxNPC=30,
    Extents=10,
    Concentration=0.225,
    -- Few monsters, many rooms
    Buildings=124,
    SpawnDelta=2.79,
    -- if math.random(10) < 2.79 then Spawn()
    -- ~28% Spawn chance
    Bartering={
      MagicDelta=.05, -- 5%             (5)
      BlackMagicDelta=.25, -- 25%       (30)
      FoodDelta=.075, -- 7.5%           (37.5%)
      MedicalDelta=.075, -- 7.5%        (45)
      CharmsDelta=.05, -- 5%            (50)
      CompanionsDelta=.25, -- 25%       (75)
      BlackMagicCharmsDelta=.25 -- 25%  (100)
    }
  },
  palace={
    MaxNPC=80,
    Extents=20,
    Concentration=3.25,
    -- Large families
    Buildings=75,
    SpawnDelta=6.09375,
    -- if math.random(10) < 6.09375 then Spawn()
    -- ~61% spawn chance
    Bartering={
      MagicDelta=.125, -- 12.5%           (12.5)
      BlackMagicDelta=.075, -- 7.5%       (20)
      FoodDelta=.15, -- 15%               (35)
      MedicalDelta=.25, -- 25%            (60)
      CharmsDelta=.1, -- 10%              (70)
      CompanionsDelta=.2, -- 20%          (90)
      BlackMagicCompanionsdelta=.1 -- 10% (100)
    }
  }
};

return CONFIG;