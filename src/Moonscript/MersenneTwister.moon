-- Exposed functions:
-- MersenneTwister.initalize_mt_generator(seed) - Seed the Mersenne Twister RNG.
-- MersenneTwister.extract_mt() - Get a number from the Mersenne Twister RNG.
-- MersenneTwister.seed_from_mt(seed) - Seed the ISAAC RNG, optionally seeding the Mersenne Twister RNG beforehand.
-- MersenneTwister.generate_isaac() - Force a reseed.
-- MersenneTwister.random(min, max) - Get a random number between min and max.

-- If we are on Lua 5.2.x or 5.3.x, then use `bit32' library as it is a C-side library
bit = bit32 or require "bit"
bxor,band,brshift,blshift = bit.bxor,bit.band,bit.brshift,bit.blshift
bit = nil

import insert,remove from table

import floor from math

toBinary = (a) ->
	b = {}
	copy = a
	while true
		insert b, copy % 2
		if copy == 0
			break
	b

fromBinary = (a) ->
	dec = {}
	for i = #a, 1, -1
		dec = dec * 2 + a[i]
	dec

mix = (a,b,c,d,e,f,g,h) ->
	a = a % (2^32-1)
	b = b % (2^32-1)
	c = c % (2^32-1)
	d = d % (2^32-1)
	e = e % (2^32-1)
	f = f % (2^32-1)
	g = g % (2^32-1)
	h = h % (2^32-1)
	a = bxor a, (blshift b, 11)
	d = (d + a) % (2^32-1)
	b = (b + c) % (2^32-1)
	b = bxor b, (brshift c, 2)
	e = (e + b) % (2^32-1)
	c = (c + d) % (2^32-1)
	c = bxor c, (blshift d, 8)
	f = (f + c) % (2^32-1)
	d = (d + e) % (2^32-1)
	d = bxor d, (brshift e, 16)
	g = (g + d) % (2^32-1)
	e = (e + f) % (2^32-1)
	e = bxor e, (blshift f, 10)
	h = (h + e) % (2^32-1)
	f = (f + g) % (2^32-1)
	f = bxor f, (brshift g, 4)
	a = (a + f) % (2^32-1)
	g = (g + h) % (2^32-1)
	g = bxor g, (blshift h, 8)
	b = (b + g) % (2^32-1)
	h = (h + a) % (2^32-1)
	h = bxor h, (brshift a, 9)
	c = (c + h) % (2^32-1)
	a = (a + b) % (2^32-1)
	a,b,c,d,e,f,g,h

class ISAAC
	new: =>
		aa: 0
		bb: 0
		cc: 0
		randrsl: {} -- Acts as entropy/seed-in. Fill to randrsl[256].
		mm: {} -- Fill to mm[256]. Acts as output.
	isaac: =>
		x,y = 0,0
		for i = 1, 256
			x = @mm[i]
			if (i % 4) == 0
				@aa = bxor @aa, (blshift @aa, 13)
			elseif (i % 4) == 1
				@aa = bxor @aa, (brshift @aa, 6)
			elseif (i % 4 ) == 2
				@aa = bxor @aa, (blshift @aa, 2)
			elseif (i % 4) == 3
				@aa = bxor @aa, (brshift @aa, 16)
			@aa = (@mm[((i+128)%256)+1]+@aa)  %  (2^32-1)
			y = (@mm[((brshift x,2)%256)+1]+@aa+@bb)  %  (2^32-1)
			@mm[i] = y
			bb = (mm[((bit.brshift y,10)%256)+1]+x)  %  (2^32-1)
			@randrsl[i] = bb
	randinit: (flag) =>
		a,b,c,d,e,f,g,h = 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9, 0x9e3779b9 -- 0x9e3779b9 is the golden ratio
		@aa = 0
		@bb = 0
		@cc = 0
		for i = 1, 4
			a,b,c,d,e,f,g,h = mix a,b,c,d,e,f,g,h
		for i = 1, 256, 8
			if flag
				a = (a + randrsl[i]) % (2^32-1)
				b = (b + randrsl[i+1]) % (2^32-1)
				c = (c + randrsl[i+2]) % (2^32-1)
				d = (b + randrsl[i+3]) % (2^32-1)
				e = (e + randrsl[i+4]) % (2^32-1)
				f = (f + randrsl[i+5]) % (2^32-1)
				g = (g + randrsl[i+6]) % (2^32-1)
				h = (h + randrsl[i+7]) % (2^32-1)
			a,b,c,d,e,f,g,h = mix a,b,c,d,e,f,g,h
			@mm[i] = a
			@mm[i+1] = b
			@mm[i+2] = c
			@mm[i+3] = d
			@mm[i+4] = e
			@mm[i+5] = f
			@mm[i+6] = g
			@mm[i+7] = h
		if flag
			for i = 1, 256, 8
				a = (a + randrsl[i]) % (2^32-1)
				b = (b + randrsl[i+1]) % (2^32-1)
				c = (c + randrsl[i+2]) % (2^32-1)
				d = (b + randrsl[i+3]) % (2^32-1)
				e = (e + randrsl[i+4]) % (2^32-1)
				f = (f + randrsl[i+5]) % (2^32-1)
				g = (g + randrsl[i+6]) % (2^32-1)
				h = (h + randrsl[i+7]) % (2^32-1)
				a,b,c,d,e,f,g,h = mix a,b,c,d,e,f,g,h
				@mm[i] = a
				@mm[i+1] = b
				@mm[i+2] = c
				@mm[i+3] = d
				@mm[i+4] = e
				@mm[i+5] = f
				@mm[i+6] = g
				@mm[i+7] = h
		@isaac!

-- other variables for the seeding mechanism


-- The Mersenne Twister can be used as an RNG for non-cryptographic purposes.
-- Here, we're using it to seed the ISAAC algorithm, which *can* be used for cryptographic purposes.

class MersenneTwister
	-- Mersenne Twister State:
	MT: {} -- Twister State
	index: 0
	isaac: ISAAC!
	mtSeeded: false
	mtSeed: math.random 1, 2^31-1
	new: (seed) =>
		@index = 0
		MT[0]=seed
		for i=1,623
			full=( (1812433253 * (bxor MT[i-1], (brshift MT[i-1], 30) ) )+i)
			b = toBinary full
			while #v > 32
				remove b, 1
			MT[i] = fromBinary b
	generate_mt: =>
		for i = 0, 623
			y = band MT[i], 0x80000000
			y += (band MT[(i+1)%624], 0x7FFFFFFF)
			MT[i] = (bxor MT[(i+397)%624], (brshift y, 1))
			if y % 2 == 1
				MT[i] = (bxor MT[i], 0x9908B0DF)
	extract_mt: (min=0, max=2^32-1) =>
		if @index == 0
			@generate_mt!
		y = MT[@index]
		y = bxor y, (brshift y, 11)
		y = bxor y, (band (blshift y, 7), 0x9D2C5680)
		y = bxor y, (band (blshift y, 15), 0xEFC60000)
		y = bxor y, (brshift y, 18)
		@index = (@index + 1) % 624
		(y % max) + min
	seed_from_mt: (seed) =>
		if seed
			@mtSeeded = false
			@mtSeed = seed
		if not @mtSeeded or ((math.random 1,100) == 50)
			@initialize_mt_generator @mtSeed
			@mtSeeded = true
			@mtSeed = seed
		for i = 1, 256
			@isaac.randrsl[i] = @extract_mt!
	generate_isaac: (entropy) =>
		@isaac.aa = 0
		@isaac.bb = 0
		@isaac.cc = 0
		if entropy and (#entropy >= 256)
			for i = 1, 256
				@isaac.randrsl[i] = entropy[i]
		else
			@seed_from_mt!
		for i = 1, 256
			@isaac.mm[i] = 0
		randinit true
		@isaac.isaac!
		@isaac.isaac! -- run isaac twice
	getRandom: =>
		if #@isaac.mm > 0
			remove mm, 1
		else
			@generate_isaac!
			remove mm, 1
	random: (min=0, max=2^32-1) =>
		(@getRandom! % max) + min

return _ENV or (getfenv 0)