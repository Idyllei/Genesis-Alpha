-- ToolBase.moon

import xround from require "utils"

class ToolBase extends BaseClass -- __extends__
	--- @param name String
	-- @param durability Integer; Remaining durability
	-- @param maxDurability Integer; Maximum durability
	-- @param callbackLeftClick Function; Called when LeftMouseButton clicked while tool equiped.
	-- @param callbackRightClick Function; Called when RightMouseButton clicked while tool equiped.
	-- @param callbackShiftLeftCLick Function; Called when <SHIFT> pressed & LeftMouseButton clicked while tool equiped.
	-- @param callbackShiftRightClick Function; Called when <SHIFT> pressed & RightMouseButton clicked while tool equiped.
	-- @param keybindingCallbacks Table; Keys are formatted keybinding strings (see KeybindStr doc) and values are callback functions.
	new: (name="Tool",durability=1,maxDurability=1,callbackLeftClick=(->),callbackRightClick=(->),callbackShiftLeftClick=(->),callbackShiftRightCLick=(->),keybindingCallbacks={}) =>
		@tags = {}
		@name = name
		@durability = (durability>=0) and durability or 0
		@maxDurability = (maxDurability>=durability) and maxDurability or durability
		@callbacks = {
			leftClick: callbackLeftClick
			rightClick: callbackRightClick
			shiftLeftClick: callbackShiftLeftCLick
			shiftRightClick: callbackShiftRightClick
		}
		for k,v in pairs keybindingCallbacks
			table.insert @callbacks, k, v
	--- @param amount Integer; The amount of damage for the tool to take
	-- @usage takeDurability 3
	takeDurability: (amount=1) =>
		@durability -= xround amount,0
		if @durability <= 0
			@destroy!
	--- @param plr Player
	-- @param shift Boolean; Player is pressing <SHIFT>
	-- @param leftClick Boolean; Player is pressing MouseButton1
	-- @param rightClick Boolean; Player is pressing MouseButton2
	-- @param subject Instance; The target of the tool (mouse hovering over)
	-- @usage use S_PLAYERS.LocalPlayer, true, false, true, Mouse.Target, ...
	use: (plr,shift,leftClick,rightClick,subject,damageTaken=1)=>
		if shift
			if leftClick
				@callbacks.shiftLeftClick!
				@durability -= 1
			elseif rightClick
				@callbacks.shiftRightClick!
				@durability -= 1
			else
				LOG\logWarn "Invalid arguements:\n\t#{prettyTab {...}}\nto #{@__name}.use(...)", nil, "Tool.#{@@__name}"
		else
			if leftClick
				@callbacks.leftClick!
				@durability -= 1
			elseif rightClick
				@callbacks.rightClick!
				@durability -= 1
			else
				LOG\logWarn "Invalid arguements:\n\t#{prettyTab {...}}\nto #{@__name}.use(...)", nil, "Tool.#{@@__name}"
