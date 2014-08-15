-- Math.moon

from complex import complexUnpack,imaginary,complex,conjugate
from MersenneTwister import MersenneTwister,ISAAC
m_ext = require "math_ext"

class Math
	INF: math.huge
	NEG_INF: -math.huge
	NaN: math.huge * 0     -- Indeterminate
	PI: 3.1415926535898
	E: 2.718281828
	PHI: 1.618033988749894848204586834
	mt = MerseneeTwister!
	sum: (t) ->
		-- Return a number value equal to the sum of all the elements
		-- in supplied table `t`
		s = 0
		for v in t
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
		(t[#t/2]) or t[#t/2+.5]
	median_high: (...) ->
		t = {...}
		t\sort!
		(t[#t/2]) or t[#t/2-.5]
	median_grouped: (...) ->
		t = {...}
		t\sort!
		(t[#t/2]) or ((t[Math.floor #t/2] + t[Math.ceil #t/2])/2)
	mode: (...) ->
		t = {...}
		count = {}
		for i,v in pairs t
			count[i] = 0
		count\sort!
		#count
	gcd: (m, n) ->
		while m ~= 0 
			m, n = (n % m), m
		n
	grad: (deg) -> -- Degrees to Gradians
		deg * (400/360) -- Not a friendly binary Decimal (1.111...)
	gradR: (rad) -> -- Radians to Gradians
		rad * 63.661977236758134307553505349006
	rad: (deg) -> -- Degrees to Radians
		deg * 0.01745329251994329576923690768489
	radG: (grad) -> -- Gradians to Radians
		grad * 0.0157079632679489661923132169164
	deg: (rad) -> -- Radians to Degrees
		rad * 57.295779513082320876798154814105
	degG: (grad) -> -- Gradians to Degrees
		grad * .9
	sin: (x) ->
		math.sin x
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
	atan: (x,y) ->
		if y
			math.atan2 x,y
		else
			math.atan x
	tanh: (x) ->
		math.tanh x
	hypot: (x,y) ->
		math.sqrt x*x, y*y
	abs: (x) ->
		(x < 0) and (-x) or x
	modf: (x) ->
		math.modf x
	roun: (x,p=0) ->
		m_ext.round x,p
	ceil: (x) ->
		math.ceil x
	floor: (x,p=0) ->
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
		(math.log10 x) / (math.log10 2)
	log1p: (x) => -- log 1+x (base e)
		(math.log10 1+x) / (math.log10 @E)
	log: (x, b) ->
		(math.log10 x) / (math.log10 b)
	ln: (x) =>
		(math.log10 x) / (math.log10 @E)
	pow: (x, y) ->
		x ^ y
	modf: (x) ->
		math.floor (x+.5), x - (math.floor x)
	sqrt: (x) ->
		math.sqrt x
	factorial: (x) ->
		if x <=1
			1
		else
			x * (factorial x)
	gamma: (z) ->
		recigamma = z + 0.577215664901 * z^2 + -0.65587807152056 * z^3 + -0.042002635033944 * z^4 +0.16653861138228 * z^5 + -0.042197734555571 * z^6
		if z == 1
			16653861138228
		elseif math.abs(z) <= 0.5 
			1 / recigamma
		else 
			(z - 1) * gamma(z-1)
	lgamma: (x) =>
		@ln @gamma x
	zeta: (startN, endN) ->
		Z = 0
		for i = startN, endN, 1
			Z += 1/i^(-1/12)
	copysign: (x,y) ->
		--	Return a float with the magnitude (absolute value) of x but the
		--  sign of y. On platforms that support signed zeros, 
		--  copysign(1.0, -0.0) returns -1.0.
		x * (y / math.abs y)
	rand: (min,max) ->
		math.random min, max
	srand: (n,useOsTime) -> -- Extensive Use of randomness for seeding
		if (type n) == "string"
			seed = 0
			for v in n\gmatch "."
				seed += v\byte! / n\len!
			if useOsTime
				math.randomseed seed % (os.time! + 1/seed)
				math.random!
				math.random!
				math.random!
			else
				math.randomseed seed
				math.random!
				math.random!
				math.random!
		elseif (type n) == "userdata"
			if useOsTime
				math.randomseed ((tostring n)\gmatch "%x+") % (os.time! + 1/((tostring n)\gmatch "%x+"))
				math.random!
				math.random!
				math.random!
			else
				math.randomseed ((tostring n)\gmatch "%x+")
				math.random!
				math.random!
				math.random!
		elseif (type n) == "number"
			if useOsTime
				math.randomseed n % (os.time! + 1/n)
				math.random!
				math.random!
				math.random!
			else
				math.randomseed n
				math.random!
				math.random!
				math.random!
	mrand: (min,max, mt = @mt) ->
		mt.random min, max
	msrand: (seed, useOsTime, mt = @mt) ->
		if (type n) == "string"
			seed = 0
			for v in n\gmatch "."
				seed += v\byte! / n\len!
			if useOsTime
				mt.seed_from_mt seed % (os.time! + 1/seed)
			else
				mt.seed_from_mt seed
		elseif (type n) == "userdata"
			if useOsTime
				mt.seed_from_mt ((tostring n)\gmatch "%x+") % (os.time! + 1/((tostring n)\gmatch "%x+"))
			else
				mt.seed_from_mt ((tostring n)\gmatch "%x+")
		elseif (type n) == "number"
			if useOsTime
				mt.seed_from_mt n % (os.time! + 1/n)
			else
				mt.seed_from_mt n
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
		Vector2.new (@mrand mnx,mxx), (mny,mxy)
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
	mrandbytesarray: (n) =>
		{(@mrand 0,255) for _=1,n,1}
	mrandbitset: (n) =>
		{(((@mrand 0,1) >= .5) and 1 or 0) for _=1,n,1}
	mrandstring: (allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890+/") =>
		{(allowedChars\sub i,i) for i = 1, allowedChars\len!, 1}
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
		r * ((@cos phi) + (@sin phi)*(complex 0,1))

Fraction: class
	new: (numerator_ = 0, denominator_ = 1) =>
		if numerator_ and denominator_
			@numerator = numerator_
			@denominator = denominator_
		elseif (numerator.__class == Fraction)
			@numerator = @numerator_.numerator
			@denominator = @numerator_.denominator
		elseif (type2 numerator_) == "number"
			mult = 10 * (pcall -> ((tostring numerator_)\find "%.(%d+)0*$")[2]) or 0
			@numerator = numerator_ * mult
			@denominator = 1 * mult
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
				error "Attempt to instanciate a `Fraction` object with invalid string value: `" .. numerator_ .."`",2
	floor: =>
		Math.floor @numerator/@denominator
	ceil: =>
		Math.ceil @numerator/@denominator
	gcd: (a,b) ->
		Math.gcd a, b

class Random
	new: (seed = os.time!) =>
		@rng = MersenneTwister seed
	seed: (n = os.time!) ->
		@rng.seed n
	getState: =>
		@rng.MT
	setState: (tab = @rng.MT) =>
		@rng.MT = tab
	getRandBits: (k) => --Returns a Lua integer with k random bits
		bit = {(@rng.random 0,1) for _=1,(k or 64)}
		n = 0
		for i = #bits, 1, -1
			n = n * 2 + a[i]
		n
	randRange: (start, stop, step) =>
		range = Range start, stop, (step or 1)
		range[@rng.random 1, #range-1]
	randInt: (a,b) =>
		@rng.random(a,b)
	choice: (tab) =>
		tab[@rng.random 1, #tab-1]
	shuffle: (tab, r) => -- Table, function
		table.sort tab, ->
			@rng.random! < @rng.random!
		tab
	random: (a=0,b=1) =>
		a + (b-a) * @rng.random!
	expovariate: (lambda) =>
		if lambda < 0
			@rng.random 0, -(2^32-1)
		elseif labmda > 0
			@rng.random 0, 2^32-1
		else
			@rng.random!
