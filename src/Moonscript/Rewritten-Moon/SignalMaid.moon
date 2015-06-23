-- SignalMaid.moon
-- Version: 2

-- CHANGES:
-- 6/18/15 8:00 PM - Ported to OOP structure; removed SignalMaid.__FIRE_THREADS

import True, thread from TypeTools

class SignalMaid
  -- <Begin class Signal>
  class Signal
    CreateSignal = assert(LoadLibrary('RbxUtility')).CreateSignal

    -- Used to wrap the function used for firing the signals.
    WrapFunc = (f) ->
      thread (...) ->
        state = ...
        while True
          coroutine.yield state or ...
          f state or ...

    create: (FArgsToFire, FWhenToFire) =>
      setmetatable {@@CreateSignal!, FArgsToFire, @@WrapFunc FWhenToFire}, {
        __call: (...) => rawget(self, 1)!
      }
  -- <End class Signal>

  -- __SIGNALS Structue: 
  -- {
  --   Signal s,
  --   Function GenArgs,
  --   Function WhenToFire
  -- }
  __SIGNALS: {}

  -- Functions

  make: (EventName, FWhenToFire=(-> None), FArgsToFire =(-> None)) =>
    assert type(EventName) == 'string', 'SignalMaid\make(EventName, FWhenToFire, FArgsToFire): not passed arg `EventName`'
    assert not @@__SIGNALS[EventName], 'SignalMaid\make Attempt to instantiate more than one Signal with identical name.'
    @@__SIGNALS[EventName] = Signal.create FArgsToFire, FWhenToFire
    
  run: =>
    for index, {Signal, ArgsToFire, WhenToFire} in pairs @@__SIGNALS
      fire, args = WhenToFire.resume!
      if fire -- Event ...args or GenArgs!
        Signal unpack(args) or ArgsToFire!
    true -- reutrn true for the @auto! call debouncing

  auto: =>
    Spawn ->
      FinishedIter = true
      while FinishedIter and wait!
        FinishedIter = false
        FinishedIter = @run!

  getSignal: (EventName) =>
    assert EventName, 'SignalMaid\getSignal: attempt to retreive invalid signal: #{EventName}'
    @@__SIGNALS[EventName]

  getEvent: (EventName) => @GetSignal EventName

  removeSignal: (EventName) =>
    assert EventName, 'SignalMaid\removeSignal: Attempt to remove invalid signal: #{EventName}'
    @@__SIGNALS\remove EventName

  deleteSignal: (EventName) => @RemoveSignal EventName

  removeEvent: (EventName) => @RemoveSignal EventName

  deleteEvent: (EventName) => @RemoveSignal EventName 