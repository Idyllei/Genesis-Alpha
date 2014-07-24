M = {}

M.yu = (num,base)=>
	1/@factorial math.log(num,base)

M.derivative = (f,delta) ->
	delta or= 1e-4
	(x) ->
		(f(x+delta)-f(x))/delta

M.invYu = (x) =>
	1/@invfactorial x

M.factorial = (x) =>
	x * (x>1 and @factorial(x-1) or 1)

M.invfactorial = (x) =>
	currN=math.floor(x/2)
	for i=currN,2,-1
		currN=x/i%1==0 and i or currN
	(@factorial(currN) == x) and currN or error("Unexpected error.")

M.integral = (func,start,stop,delta) ->
	delta or= 1e-4
	int = 0
	for i=start,stop,delta
		int = int + func(i)*dalta
	int

M.recigamma = (z) ->
	z + 0.577215664901 * z^2 + -0.65587807152056 * z^3 + -0.042002635033944 * z^4 + 0.16653861138228 * z^5 + -0.042197734555571 * z^6

M.gamma = (z) =>
	if z==1
		1
	elseif math.abs(z) <= .5
		1/@recigamma(z)
	else
		(z-1) * @gamma(z-1)

M.definedAs = (func,x,E) ->
	func(x)==E

M.near = (x,E,epsilon) ->
	math.abs(x-E) <= epsilon

M.isCongruent = (a,b,property) ->
	if type a ~= type b
		error("")
	if type a == "table" and #a == #b
		if property
			a[property]==b[property]
		for i,v in pairs a
			if v ~= b[i]
				return false
			else
				return true
	elseif type a == "userdata"
		getmetatable a == getmetatable b
	else
		a==b
M.modCongruence = (a,b,n) ->
	(a-b)%n==0

M.muchDifferent = (a,b,magnitude) ->
	math.abs(a-b) >= magnitude

M.muchLessThan = (a,b,magnitude) =>
	@muchDifferent(a,b,magnitude) and a<b

M.muchGreaterThan = (a,b,magnitude) =>
	@muchDifferent(a,b,magnitude) and a>b

M.foAll = (f,set) ->
	for v in set
		if not f(v)
			return false
	true