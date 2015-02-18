-- BaseClass.moon

class BaseClass
	__extends__: (require "__Extends__").__extends__
	__is__: (require "__Is__").__is__
	crypter: (require "hashids").new (require "HIDDEN_CONFIG").dbg_hash_salt
	new: ->
		return @
	__inherited: (child) ->
		LOG\logDebug "Class #{@__name} inherited by #{child.__name}", tick!, "BaseClass"
	identity: ->
		print @__name
	hash: ->
		@crypter.encrypt _G.prettyTable @