-- ./LuaExtraUtils/Math.moon

-- Changelog:
-- Removed anonymous pcall in 'Fration.new'
-- Added 'add','sub','mul','div','pow','mod', and 'simplify' to class Fraction.
-- Renamed functions arguments from 'n' to 'x'
-- Added 'lerp' function to class Math
-- Updated the precision OF 'PI','E", & 'PHI" in class Math
import MersenneTwister,ISAAC from require "MersenneTwister"

Math =
	INF: math.huge
	NEG_INF: -math.huge
	NaN: math.huge * 0     -- Indeterminate
	PI:  3.141592653589793238462643383
	E:   2.718281828459045235360287471
	PHI: 1.618033988749894848204586834
	mt: MersenneTwister!
	new: ->
		@
	sum: (t) ->
		-- Return a number value equal to the sum of all the elements
		-- in supplied table `t`
		s = 0
		for _,v in pairs t
			s += v
	mean: (...) =>
		sum = @sum {...}
		sum / #{...}
	median: (...) ->
		t = {...}
		t\sort!
		(t[#t/2]) or ((t[Math.floor #t/2] + t[Math.ceil #t/2])/2)
	median_low: (...) ->
		t = {...}
		t\sort!
		(t[#t/2]) or t[#t/2-0.5]
	median_high: (...) ->
		t = {...}
		t\sort!
		(t[#t/2]) or t[#t/2+0.5]
	median_grouped: (...) ->
		t = {...}
		t\sort!
		(t[#t/2]) or ((t[Math.floor #t/2] + t[Math.ceil #t/2])/2)
	mode: (...) ->
		t = {...}
		count = {}
		for i,_ in pairs t
			count[i] = 0
		count\sort!
		#count
	gcd: (a,b) =>
		if b ~= 0
			gcd b, a%b
		else
			math.abs a
	gcd2: (m, x) ->
		while m ~= 0 
			m, x = (x % m), m
		x
	factors: (x) ->
		f = {}
		for i = 1, x/2
			if (x % i) == 0
				f[#f+1] = i
		f[#f+1] = x
		f
	primeFactors: (x) ->
		-- this is repetitive code as repeat-until does not exist in Moonscript
		f = {}
		if @isPrime x
			f[1] = x
		i = 2
		-- repeat 
		while (x % i) == 0
			f[#f+1] = i
			x /= i
			-- repeat
			i += 1
			while not @isPrime i
				i += 1
		while not x == 1
			while (x % i) == 0
				f[#f+1] = i
				x /= i
			-- repeat
			i += 1
			while not @isPrime i
				i += 1
		f
	isPrime: (x) ->
		x = tonumber x
		if (not x) or (x<2) or ((x%1)~=0)
			false
		elseif (x>2) and ((x%2)==0)
			false
		elseif x>5 and ((x%5)==0)
			false
		else
			for i = 3, (math.sqrt x), 2
				if ((x%i)==0)
					false
		true
	isMersennePrime: (x) =>
		true if (((@log2 (x+1))%2) == 0)
	isDoubleMersennePrime: (x) =>
		true if ((@log2 (@log2 (x+1))) == 0)
	grad: (deg) -> -- Degrees to Gradians
		deg * 1.1111111111111111111111111111111 -- Not a friendly binary Decimal (1.111...)
	rad: (deg) -> -- Degrees to Radians
		deg *  0.01745329251994329576923690768489
	deg: (rad) -> -- Radians to Degrees
		rad * 57.295779513082320876798154814105
	gradR: (rad) -> -- Radians to Gradians
		rad * 63.661977236758134307553505349006
	radG: (grad) -> -- Gradians to Radians
		grad * 0.0157079632679489661923132169164
	degG: (grad) -> -- Gradians to Degrees
		grad * .9
	sin: (n) ->
		math.sin n
	asin: (x) ->
		math.asin x
	sinh: (x) ->
		math.sinh x
	cos: (x) ->
		math.cos x
	acos: (x) ->
		math.acos x
	cosh: (x) ->
		math.cosh x
	tan: (x) ->
		math.tan x
	atan: (x, y) ->
		if y
			math.atan2 x,y
		else
			math.atan x
	atan2: (x, y) ->
		math.atan2 x, y
	tanh: (x) ->
		math.tanh x
	lerp: (a, b, c) ->
		a+(a-b)*c
	hypot: (x, y) ->
		math.sqrt x*x, y*y
	abs: (x) ->
		(x < 0) and (-x) or x
	modf: (x) ->
		math.modf x
	roun: (x,p=0) ->
		m_ext.round x,p
	ceil: (x) ->
		math.ceil x
	floor: (x, p=0) ->
		m_ext x,p
	trunc: (x) ->
		math.floor x
	min: (...) ->
		math.min ...
	max: (...) ->
		math.max ...
	exp: (x) -> -- e^x
		2.718281828 ^ x
	ldexp: (x, exp) -> -- Essentially inverse of `frexp`
		x * 2 ^ exp
	frexp: (x) -> -- essentially inverse of `ldexp`
		math.frexp x
	expm1: (x) => -- e ^ x - 1
		@E ^ x - 1
	log10: (x) -> -- log x (base 10)
		math.log10 x
	log2: (x) ->
		(math.log10 x) / 0.30102999566398119521373889472449
	log1p: (x) => -- log 1+x (base e)
		(math.log10 1+x) / 0.43429448182991108329174052088324
	log: (x, b) ->
		(math.log10 x) / (math.log10 b or 10)
	ln: (x) =>
		(math.log10 x) / 0.43429448182991108329174052088324
	pow: (x, y) ->
		-- Added if y == (2|3) for common 2D/3D equations
		x*x if y == 2
		x*x*x if y == 3
		x ^ y
	modf: (x) ->
		math.floor (x+.5), x - (math.floor x)
	sqrt: (x) ->
		math.sqrt x
	factorial: (x) =>
		if x<=1 then 1 else x*(@factorial x-1)
	gamma: (x) ->
		recigamma = x + 0.577215664901 * x^2 + -0.65587807152056 * x^3 + -0.042002635033944 * x^4 +0.16653861138228 * x^5 + -0.042197734555571 * x^6
		if x == 1
			16653861138228
		elseif math.abs(x) <= 0.5 
			1 / recigamma
		else 
			(x - 1) * @gamma(x-1)
	lgamma: (x) =>
		@ln @gamma x
	zeta: (startN, endN) ->
		Z = 0
		for i = startN, endN, 1
			Z += 1/i^(-1/12)
		z
	copysign: (x,y) ->
		--	Return a float with the magnitude (absolute value) of x but the
		--  sign of y. On platforms that support signed zeros, 
		--  copysign(1.0, -0.0) returns -1.0.
		x * (y / math.abs y)
	rand: (min=0,max=1) ->
		math.random min, max
	srand: (seed=(-> (tick!/(os.time!+tick!/os.time!)))!,useOsTime) -> -- Extensive Use of randomness for seeding
		if (type seed) == "string"
			seed = 1
			-- Set the length here so we don't do repeated (&! to say unnecessarry) calls to string.len(String s) for the length.
			len = seed\len!
			for v in seed\gmatch "."
				seed += v\byte! / len
			if useOsTime
				math.randomseed seed % (os.time! + 1/seed)
				math.random 0, (math.random 0, math.random!)
				nil
			else
				math.randomseed seed
				math.random 0, (math.random 0, math.random!)
				nil
		elseif (type seed) == "userdata"
			if useOsTime
				math.randomseed ((tonumber (tostring seed)\gmatch "%x+")) % (os.time! + 1/(tonumber (tostring seed)\gmatch "%x+"))
				math.random 0, (math.random 0, math.random!)
				nil
			else
				math.randomseed (tonumber (tostring seed)\gmatch "%x+")
				math.random 0, (math.random 0, math.random!)
				nil
		elseif (type seed) == "number"
			if useOsTime
				math.randomseed seed % (os.time! + 1/seed)
				math.random 0, (math.random 0, math.random!)
				nil
			else
				math.randomseed seed
				math.random 0, (math.random 0, math.random!)
				nil
	mrand: (min, max, mt = @mt) ->
		mt.random min, max
	msrand: (seed, useOsTime, mt = @mt) ->
		if (type seed) == "string"
			seed = 0
			-- Set the length here so we don't do repeated (&! to say unnecessarry) calls to string.len(String s) for the length.
			len = seed\len!
			for v in seed\gmatch "."
				seed += v\byte! / len
			if useOsTime
				mt.seed_from_mt seed % (os.time! + 1/seed)
			else
				mt.seed_from_mt seed
		elseif (type seed) == "userdata"
			if useOsTime
				mt.seed_from_mt ((tonumber (tostring seed)\gmatch "%x+")) % (os.time! + 1/((tostring seed)\gmatch "%x+"))
			else
				mt.seed_from_mt (tonumber (tostring seed)\gmatch "%x+")
		elseif (type seed) == "number"
			if useOsTime
				mt.seed_from_mt seed % (os.time! + 1/seed)
			else
				mt.seed_from_mt seed
	mreseed: (mt = @mt) -> -- force reseed
		mt.generate_isaac!
	mrandextract: (mt = @mt) ->
		mt.extract_mt!
	mrandfloat: (min, max) =>
		(mt.random 0,1) * (mt.random min, max)
	mrandfloatarray: (size,min,max) =>
		{(@mrandfloat min,max) for _ = 1,size,1}
	mrandarray: (size) =>
		{(@mrand 0,1) for _=1,size,1}
	mrandvector2: (mnx,mxx,mny,mxy) =>
		Vector2.new (@mrand mnx,mxx), (@mnrand mny,mxy)
	mrandvector3: (mnx,mxx,mny,mxy,mnz,mxz) =>
		Vector3.new (@mrand mnx,mxx), (@mrand mny,mxy), (@mrand mnz,mxz)
	mrandcframe: (mnx,mxx,mny,mxy,mnz,mxz,mnx2,mxx2,mny2,mxy2,mnz2,mxz2) =>
		(CFrame.new (@mrand mnx,mxx), (@mrand mny,mxy), (@mrand mnz,mxz)) * (CFrame.new (@mrand mnx2,mxx2), (@mrand mny2,mxy2), (@mrand mnz2,mxz2))
	mrandudim: (mns,mxs,mno,mxo)  =>
		UDim.new (@mrand mns,mxs), (@mrand mno,mxo)
	mrandudim2: (mnxs,mxxs,mnxo,mxxo,mnys,mxys,mnyo,mxyo) =>
		UDim2.new (@mrand mnxs,mxxs), (@mrand mnxo,mxxo), (@mrand mnys,mxys), (@mrand mnyo,mxyo)
	mrandcolor3: =>
		Color3.new (@mrand 0,1), (@mrand 0,1), (@mrand 0,1)
	mrandbrickcolor: =>
		BrickColor.new @mrandcolor3!
	mrandbytesarray: (x) =>
		{(@mrand 0,255) for _=1,x}
	mrandbitset: (x) =>
		{(((@mrand 0,1) >= .5) and 1 or 0) for _=1,x}
	mrandstring: (size=16, allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890+/") =>
		allowedLen = allowedChars\len!
		{(allowedChars\sub charIndex,charIndex) for _ = 1, (math.floor size), 1 do charIndex = (math.random allowedLen)}
	mrandbool: =>
		(@mrand 0,1) >= .5
	isfinite: (x) =>
		((math.abs x) ~= @INF) and (x ~= @NaN)
	isinfinite: (x) =>
		((math.abs x) == @INF)
	isnan: (x) =>
		x == @NaN
	phase: (x) =>
		@atan complexUnpack x
	polar: (x) =>
		{(@abs x), (@phase x)}
	rect: (r, phi) => -- RETURNS COMPLEX NUMBER!
						-- Python:
						-- >>>   r * (math.cos(phi) + math.sin(phi)*1j)
		(Complex 0,1)\mult ((@cos phi)+(@sin phi))\mult r
	sum_E_lim: (start,end_,f,env) =>
		eta = ->
			s = 0
			for x = start, end_
				s += f x
			s
		setfenv eta, (env or getfenv!)
		eta!
	sum_E_lim_t: (start_end, f, env) ->
		lambda = ->
			s = 0
			for x = start_end[1], start_end[2]
				s += f x
			s
		setfenv lambda, (env or getfenv!)
		lambda!
	sum_E_elem_t: (set, f, env) =>
		lambda = ->
			s = 0
			for _,x in pairs set
				s += f x
			s
		setfenv lambda, (env or getfenv!)
		lambda!

	integral_trapezoidal_basic: (f, a, b) -> 
		(b-a)* f (a+b)/2
	integral_trapezoidal: (a,b,f,intervals) =>
		func = ->
			f (a+b*((b-a)/intervals))
		((b-a)/intervals)*((f a)/2 + (@sum_E_lim 1, (intervals-1), func, getfenv!)) + (f b)/2
	
class Fraction
	new: (numerator_ = 0, denominator_ = 1) =>
		if numerator_ and denominator_
			@numerator = numerator_
			@denominator = denominator_
		elseif (numerator.__class == Fraction)
			@numerator = @numerator_.numerator
			@denominator = @numerator_.denominator
		elseif (type2 numerator_) == "number"
			mult = 10 * ((tostring numerator_)\find "%.(%d+)0*$")[2] or 0
			@numerator = numerator_ * mult
			@denominator = mult
			gcd = Math.gcd @numerator, @denominator
			@numerator /= gcd
			@denominator /= gcd
		elseif (type numerator_) == "string"
			numerator_ = numerator_\gsub "%s", ""
			if numerator_\find "/"
				@numerator = tonumber (numerator_\sub (numerator_ find "^%d*")) or 0
				@denominator = tonumber (denominator_\sub (denominator_ find "%d*$")) or 1
			elseif numerator_\find "."
				Fraction tonumber numerator_
			else
				LOG\logError "Attempt to instanciate a `Fraction` object with invalid string value: #{numerator_}", nil, "Math.Fraction"
	simplify: =>
		gcd = Math.gcd @numerator, @denominator
		@numerator /= gcd
		@denominator /= gcd
		@
	mult: (other) =>
		if other.__type == Fraction
			F = Fraction (@numerator * other.numerator), (@denominator * other.denominator)
			F\simplify!
	div: (other) =>
		F = Fraction (@numerator * other.denominator), (@denominator * other.numerator)
		F\simplify!
	add: (other) =>
		if (@denominator ~= other.denominator)
			sD = @denominator
			oD = other.denominator

			other.denominator *= sD
			@denominator *= oD

			@numerator += other.numerator

			@simplify!
		else
			@numerator += other.numerator
			@simplify!
	sub: (other) =>
		if (@denominator ~= other.denominator)
			sD = @denominator
			oD = other.denominator

			other.denominator *= sD
			@denominator *= oD

			@numerator -= other.numerator

			@simplify!
	pow: (n) =>
		@numerator = @numerator ^ n
		@denominator = @denominator ^ n
		@simplify!
	root: (r) =>
		@pow 1/r
	mod: (n) =>
		if (n.__type == Fraction)
			@sub (other*(math.floor @div other))
	floor: =>
		Math.floor @numerator/@denominator
	ceil: =>
		Math.ceil @numerator/@denominator
	gcd: (a,b) ->
		Math.gcd a, b
	range: (start, stop, step) ->
		{n for n = start, stop, step}

class Random
	new: (seed=os.time!) =>
		@mt = MersenneTwister seed
	seed: (n=os.time!) ->
		@mt.seed n
	getState: =>
		@mt.MT
	setState: (tab=@mt.MT) =>
		@mt.MT = tab
	getRandBits: (k=64) => --Returns a Lua integer with k random bits
		bit = {@mt.random 0,1 for _=1,k} 
		n = 0
		for i = #bits, 1, -1
			n = n * 2 + bits[i]
		n
	randRange: (start, stop, step=1, min=0, max=1) =>
		{@mt.random min,max for i = start, stop, step}
	randInt: (a,b) =>
		@mt.random(a,b)
	choice: (tab) =>
		tab[@mt.random 1, #tab-1]
	shuffle: (t) => -- Table, function
		n = #t
		while n >= 2
			k = @mt.rand n
			t[n], t[k] = t[k], t[n]
			n -= 1
		t
	random: (a=0,b=Math.PHI) =>
		a + (b-a) * @mt.random!
	expovariate: (lambda) =>
		if lambda < 0
			@mt.random 0, -(2^32-1)
		elseif labmda > 0
			@mt.random 0, 2^32-1
		else
			@mt.random!

return {
	Complex: (require "BaseTypes").Complex
	:Fraction
	:Math
	:Random
}