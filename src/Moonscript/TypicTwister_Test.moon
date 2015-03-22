-- TypicTwister_Test.moon

TypicTwister = require "TypicTwister"

for seed = 1, 10, .5
	for min = 1, 100
		for max = 100, 500
			print "Seed: #{seed}\nMin: #{min}\nMax: #{max}"
			rng = TypicTwister seed
			rand = rng.random min, max
			print "Random Number: #{rand}"