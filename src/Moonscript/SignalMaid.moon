-- SignalMaid.moon

do
  
  
  class SignalMaid
  	__SIGNALS = {} -- Holds the Signals to be interfaced with, keys are Strings, values are LuaSignals
  	__FIRE_THREADS = {} -- Holds functions to check if corresponding Evt should be fired. Key: String Value: function
  	CreateSignal = (assert LoadLibrary "RbxUtility").CreateSignal
  	WrapFunc = (f) ->
  		return coroutine.create (...)->
  			while 1
  				coroutine.yield ... -- Keep the references active
  				f ...
  	new: (sEvtName, fWhenToFire, fArgsToFire) => 
  		-- fWhenToFire should return a boolean value (true = fire) and a table of arguements to fire the event with
      if not sEvtName-- Make sure the LuaSignal was given a name.
      	print "[WARN] [SignalMaid] Attempt to create unnamed LuaSignal in SignalMaid", 2
      	return false
      if @@__SIGNALS[sEvtName] -- Make sure we aren't going to overwrite an already created LuaSignal
      	print "[WARN] [IGNORED] [SignalMaid] Attempt to create a LuaSignal with a name already used as index."
        return false
			@@__SIGNALS[sEvtName] = {@@CreateSignal!, fArgsToFire} -- Make a new signal as the event.
			@@__FIRE_THREADS[sEvtName] = @@WrapFunc fWhenToFire
			return true
		run: ()=>
			for sEvtName, fWhenToFire in pairs __FIRE_THREADS
				bFire, args = fWhenToFire.resume!
				if passed -- Fire with the given arguements ro those passed by fWhenToFire
					__SIGNALS[sEvtName][1]\fire (__SIGNALS[sEvtName][2] or unpack args)
			true
		auto: ()=>
			Spawn ->
				bFinishedIter = true -- Debounce this loop just in case
				while bFinishedIter and wait!
					bFinishedIter = false
					bFinishedIter = @run!
		getSignal: (sEvtName) =>
			if not sEvtName
				print "[WARN] [IGNORED] [SignalMaid] Attempt to retrieve invalid LuaSignal: '#{sEvtName}'"
				return false
			__SIGNALS[sEvtName]
		getEvent: (sEvtName) =>
			@getSignal sEvtName
		removeSignal: (sEvtName) =>
			if not sEvtName
				print "[WARN] [IGNORED] [SignalMaid] Attempt to delete invalid LuaSignal: '#{sEvtName}'"
				return false
			-- Remove the table entries for the Event
			__SIGNALS\remove sEvtName
			__FIRE_THREADS\remove sEvtName
			true
		deleteSignal: (sEvtName) => -- alias removeSignal
			@removeSignal sEvtName
		removeEvent: (sEvtName) => -- alias removeSignal
			@removeSignal sEvtName
		deleteEvent: (sEvtName) => -- alias removeSignal
			@removeSignal sEvtName