-- TypicTwister.moon
bit = (require "bit") or (require "bit.numberlua")
f = (x) -> x ^ math.abs (math.sin x + 1/x)*(math.cos 1/x)
g = (x) -> 
	if (x >= 1) and (x <=2)
		math.sin 2.718281828^(x/1.618335)
	else
		f (f x) + (f math.cos x/(x-1))
H = (x,y) -> 
	if (x == 1) and (y == 1)
		0.97978047694786
	else
		g (math.sin x^-y + 1/y)*(math.cos y^-x + 1/x)
J = (x,y) -> math.sin (x + 1/y) % (y + 1/x + 1)

curry = (f, nArgs) ->
	nArgs or= 2
	if nArgs <= 1
		f
	curry_h = (argtrace, n) ->
		if n == 0
			f reverse argtrace!
		else
			return ->
				(curry_h -> onearg, argtrace), n-1
	return (curry_h (->), num_args)

reverse = (...) ->
	reverse_h = (acc, v, ...) ->
		if (select '#', ...) == 0
			v, acc!
		else
			(reverse_h (-> v, acc), ...)
	return (reverse_h (->), ...)

-- Output the values of f, g, H, and J:
-- f(x)
for x = 1, 20
	print "f(#{x}): " .. (f x)
print "\n\n"
-- g(x)
for x = 1, 20
	print "g(#{x}): " .. (g x)
print "\n\n"
-- H(x,y)
for x = 1, 10
	for y = 1, 10
		print "H(#{x},#{y}): " .. (H x, y)
print "\n\n"
-- J(x,y)
for x = 1, 10
	for y = 1, 10
		print "J(#{x},#{y}): " .. (J x, y)
class TypicTwister
	M = {}
	new: (a,b) =>
		a = bit.bxor (bit.rrotate a,3), 255
		b = bit.bxor (bit.lrotate b,3), 255
	random: (min,max) =>
		M[1] = MersenneTwister a
		M[2] = MersenneTwister b
		A = f M[1].random 1, 1024
		B = f M[2].random 1, 1024
		C = math.abs A-B
		H1 = (curry H) C
		D = g C
		M[3] = MersenneTwister f C
		M3_out = m[3].random!
		if @run_once
			M[4] = MersenneTwister M[4].random!
			M[5] = MersenneTwister M[5].random!
		else
			M[4] = MersenneTwister M3_out
			M[5] = MersenneTwister M3_out
		H2 = (curry H) M3_out
		M[6] = MersenneTwister H2 ((curry J) D) M[5].random!
		M[6].random min, max

return ->
	{
		TypicTwister: TypicTwister,
		curry: curry,
		reverse: reverse,
		f: f,
		g: g,
		H: H,
		J: J	
	}