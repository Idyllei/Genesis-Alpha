moonscript = require "moon.all"

class Clazz
	new: (mInt1=0,mInt1={"abc"}, mStr1="") =>
		@mInt1 = mInt1
		@mTab1 = mTab1
		@mStr1 = mStr1
	printValues: =>
		print "#{@mInt1}, #{@mInt2}, #{@mTab1}, #{@mTab2}, #{@mstr1}, #{@mStr2}"
	getReturn: ->
		1

moonscript.p Clazz!