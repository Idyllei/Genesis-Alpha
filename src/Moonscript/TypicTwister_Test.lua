local TypicTwister = require("TypicTwister")
for seed = 1, 10, .5 do
  for min = 1, 100 do
    for max = 100, 500 do
      print("Seed: " .. tostring(seed) .. "\nMin: " .. tostring(min) .. "\nMax: " .. tostring(max))
      local rng = TypicTwister(seed)
      local rand = rng.random(min, max)
      print("Random Number: " .. tostring(rand))
    end
  end
end
