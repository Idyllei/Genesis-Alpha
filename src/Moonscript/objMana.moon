API = require "API"

class Mana
	new: (player,baseMx=100,r=100,xpl=0,xpa=0) =>
		@absMax: 10000
		@player = API.getPlayer player
		@baseMax = baseMx
		@remaining = r
		@experience = {
			level: xpl
			amt: xpa
		}
		self
	addExperience: (amt=0) =>
		@experience.amt += amt
		self
	calcXpForLvlUp: =>
		x = @experience.level+1
		1.25*math.sqrt(x^3)*(x/math.sqrt(2.5*x)+2.5)/(x/math.log(x))*x+10
	recalculateLevel: =>
		if @experience.amt >= @calcXpForLvlUp!
			@experience.level += 1
			@recalculateLevel!
	useMana: (amt=0) =>
		if amt < 0
			error "",2
		@experience.amt += (math.floor amt) / 100
		@remaining -= math.ceil amt
		@recalculateLevel!
		return @remaining,@experience.amt
	replenishMana: (amt=0) =>
		if amt < 0
			error "",2
		@remaining = math.min @remaining+amt,@absMax
		self
	__unm: =>
		with Mana @player
			.baseMax = 0
			.absMax = 0
			.remaining = 0
			.experience.level = 0
			.experience.amt = 0
	__add: (other) =>
		if other.__class == self.__class
			newMana = with Mana @player
				.baseMax = .baseMax + other.baseMax
				.remaining = .remaining + other.remaining
				.experience.level = .experience.level + other.experience.level
				.experience.amt = .experience.amt + other.experience.amt
			for i,v in pairs self
				if v < 0
					self[i] = 0
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif other = tonumber other
			newMana = with Mana @player
				.baseMax = .baseMax + other
				.remaining = .remaining + other
				.experience.level = .experience.level + other
				.experience.amt = .experience.amt + other
			for i,v in pairs self
				if v < 0
					self[i] = 0
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif (type other) == "table"
			newMana = with Mana @player
				.baseMax = .baseMax + other[1]
				.remaining = .remaining + other[2]
				.experience.level = .experience.level + other[3][1]
				.experience.amt = .experience.amt + other[3][2]
			for i,v in pairs self
				if v < 0
					self[i] = 0
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
	__sub: (other) =>
		if other.__class == self.__class
			newMana = with Mana @player
				.baseMax = .baseMax - other.baseMax
				.remaining = .remaining - other.remaining
				.experience.level = .experience.level - other.experience.level
				.experience.amt = .experience.amt - other.experience.amt
			for i,v in pairs self
				if v < 0
					self[i] = 0
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif other = tonumber other
			newMana = with Mana @player
				.baseMax = .baseMax - other
				.remaining = .remaining - other
				.experience.level = .experience.level - other
				.experience.amt = .experience.amt - other
			for i,v in pairs self
				if v < 0
					self[i] = 0
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif (type other) == "table"
			newMana = with Mana @player
				.baseMax = .baseMax - other[1]
				.remaining = .remaining - other[2]
				.experience.level = .experience.level - other[3][1]
				.experience.amt = .experience.amt - other[3][2]
			for i,v in pairs self
				if v < 0
					self[i] = 0
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
	__mul: (other) =>
		if other.__class == self.__class
			newMana = with Mana @player
				.baseMax = .baseMax * other.baseMax
				.remaining = .remaining * other.remaining
				.experience.level = .experience.level * other.experience.level
				.experience.amt = .experience.amt * other.experience.amt
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif other = tonumber other
			newMana = with Mana @player
				.baseMax = .baseMax * other
				.remaining = .remaining * other
				.experience.level = .experience.level * other
				.experience.amt = .experience.amt * other
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif (type other) == "table"
			newMana = with Mana @player
				.baseMax = .baseMax * other[1]
				.remaining = .remaining * other[2]
				.experience.level = .experience.level * other[3][1]
				.experience.amt = .experience.amt * other[3][2]
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
	__div: (other) =>
		if other.__class == self.__class
			newMana = with Mana @player
				.baseMax = .baseMax / other.baseMax
				.remaining = .remaining / other.remaining
				.experience.level = .experience.level / other.experience.level
				.experience.amt = .experience.amt / other.experience.amt
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif tonumber other
			newMana = with Mana @player
				.baseMax = .baseMax / other
				.remaining = .remaining / other
				.experience.level = .experience.level / other
				.experience.amt = .experience.amt / other
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif (type other) == "table"
			newMana = with Mana @player
				.baseMax = .baseMax / other[1]
				.remaining = .remaining / other[2]
				.experience.level = .experience.level / other[3][1]
				.experience.amt = .experience.amt / other[3][2]
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
	__mod: (other) =>
		if other.__class == self.__class
			newMana = with Mana @player
				.baseMax = .baseMax % other.baseMax
				.remaining = .remaining % other.remaining
				.experience.level = .experience.levle % other.experience.level
				.experience.amt = .experience.amt % other.experience.amt
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif tonumber other
			newMana = with Mana @player
				.baseMax = .baseMax % other
				.remaining = .remaining % other
				.experience.level = .experience.level % other
				.experience.amt = .experience.amt % other
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif (type other) == "table"
			newMana = with Mana @player
				.baseMax = .baseMax % other[1]
				.remaining = .remaining % other[2]
				.experience.level = .experience.levle % other[3][1]
				.experience.amt = .experience.amt % other[3][2]
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
	__pow: (other) =>
		if other.__class == self.__class
			newMana = with Mana @player
				.baseMax = .baseMax ^ other.baseMax
				.remaining = .remaining ^ other.remaining
				.experience.level = .experience.level ^ other.experience.level
				.experience.amt = .experience.amt ^ other.experience.amt
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif tonumber other
			newMana = with Mana @player
				.baseMax = .baseMax ^ other
				.remaining = .remaining ^ other
				.experience.level = .experience.level ^ other
				.experience.amt = .experience.amt ^ other
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
		elseif (type other) == "table"
			newMana = with Mana @player
				.baseMax = .baseMax ^ other[1]
				.remaining = .remaining ^ other[2]
				.experience.level = .experience.level ^ other[3][1]
				.experience.amt = .experience.amt ^ other[3][2]
			newMana.baseMax = math.min newMana.baseMax, newMana.absMax
			newMana
	__idiv: (other) =>
		if other.__class == @__class
			newMana = with Mana @player
				.baseMax = math.floor (math.floor .baseMax) / (math.floor other.baseMax)
				.remaining = math.floor (math.floor .remaining) / (math.floor other.remaining)
				.experience.level = math.floor (math.floor .remaining) / (math.floor other.experience.level)
				.experience.amt = math.floor (math.floor .experience.amt) / (math.floor other.experience.amt)
			newMana
		elseif other = tonumber other
			newMana = with Mana @player
				.baseMax = math.floor (math.floor .baseMax) / (math.floor other)
				.remaining = math.floor (math.floor .remaining) / (math.floor other)
				.experience.level = math.floor (math.floor .remaining) / (math.floor other)
				.experience.amt = math.floor (math.floor .experience.amt) / (math.floor other)
			newMana
		elseif (type other) == "table"
			newMana = with Mana @player
				.baseMax = math.floor (math.floor .baseMax) / (math.floor other[1])
				.remaining = math.floor (math.floor .remaining) / (math.floor other[2])
				.experience.level = math.floor (math.floor .experience.level) / (math.floor other[3][1])
				.experience.amt = math.floor (math.floor .experience.amt) / (math.floor other[3][2])
			newMana
	__tostring: =>
		(assert LoadLibrary "RbxUtil").JSONEncode self
	__eq: (other) => -- assert @__class == @@
		(other.__class == @__class) and (@baseMax == other.baseMax) and (@remaining == other.remaining) and (@experience.level == other.experience.level) and (@experience.amt == other.experience.amt)
	__lt: (other) => -- assert @__class == @@
		(other.__class < @__class) and (@baseMax < other.baseMax) and (@remaining < other.remaining) and (@experience.level < other.experience.level) and (@experience.amt < other.experience.amt)
	__le: (other) =>
		return (self < other) or (self == other)
return Mana