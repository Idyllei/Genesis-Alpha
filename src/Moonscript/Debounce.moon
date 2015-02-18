-- Debounce.moon

-- Example Usage:
----------------------------------------------------------------------
-- local debounce = require(game.ReplicatedStorage.Modules.Debounce);
--
-- game.Workspace.Button.Touched:connect(debounce(function(hit)
--   print("Button touched!");
--   wait(3);
--   print("Waited");
-- end))
----------------------------------------------------------------------

M = {}

M.debounce = (func) -> -- function debounce(func)
	isRunning = false -- create a local debounce variable
	return (...) -> -- return a new function `return function(...)`
		if not isRunning
			isRunning = true
			func ... -- call it with original args
			isRunning = false

return M