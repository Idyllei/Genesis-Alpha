-- TaskScheduler.moon

class TaskScheduler
	new: (tSchedule, bAutoStart) =>
		-- /* 
		--  * tSchedule should be of the format:
		--  * {
		--  *    [Table<Date>]: ({String Name, Thread task}|Function task)  |
		--	*	 [Integer<Timestamp>]: ( {String Name, Thread task} | Function task)  |
		--	*	 [function]: Thread task  )
		--  * }
		--  *
		--  * bAutoStart allows the thread to start automatically when the
		--  * processor is free of currently running Lua threads.
		--  */


		tNewSchedule = {}
		for t,task in pairs tSchedule
			if (((type t) == "table") or ((type t) == "number") or ((type t) == "function")) and (((type task) == "table") and ((type task[2]) == "thread") or ((type task) == "function"))
				tNewSchedule[t] = task

		@tSchedule = tNewSchedule

		if bAutoStart
			-- loop through all key-value pairs in the schedule
			for t,task in pairs @tSchedule
				Spawn ->
					-- Key is a Table<Date>
					if (type t) == "table"
						-- turn the Table<date> into Integer<Timestamp>
						nStartTime = os.date t
						-- Wait until the startime is reached or passed
						while tick! < nStartTime
							wait 0.0625
						-- Value is a coroutine
						if (type task[2]) == "thread"
							-- Spawn new thread
							Spawn ->
								coroutine.resume task[2]
								-- Call 'wait(s)' to give other threads the chance to run
								while wait 0.0625
									if (coroutine.status task[2]) == "dead"
										Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
										break
						-- 
						elseif (type task) == "function"
							Spawn task
					elseif (type t) == "number"
						nStartTime = t
						while tick! < nStartTime
							wait 0.0625
						if (type task[2]) == "thread"
							Spawn ->
								coroutine.resume task[2]
								while wait 0.0625
									if (coroutine.status task[2]) == "dead"
										Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
										break
						elseif (type task) == "function"
							Spawn task
					elseif (type t) == "function"
						if (type task[2]) == "thread"
							Spawn ->
								-- separate thread for the task
								coroutine.resume task[2]
								-- check to make sure the timer function is still returning false
								while not t! and wait 0.0625
									-- check task status
									if (coroutine.status task[2]) == "dead"
										Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
										break
						-- 
						elseif (type task) == "function"
							Spawn task

	add: (t, task) =>
		if (((type t) == "table") or ((type t) == "number") or ((type t) == "function")) and (((type task) == "table") and ((type task[2]) == "thread") or ((type task) == "function"))
			tSchedule[t] = task
			if (type t) == "table"
				nStartTime = os.date t
				while tick! < nStartTime
					wait 0.0625
				if (type task[2]) == "thread"
					Spawn ->
						coroutine.resume task[2]
						while wait 0.0625
							if (coroutine.status task[2]) == "dead"
								Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
								break
				elseif (type task) == "function"
					Spawn task
			elseif (type t) == "number"
				nStartTime = t
				while tick! < nStartTime
					wait 0.0625
				if (type task[2]) == "thread"
					Spawn ->
						coroutine.resume task[2]
						while wait 0.0625
							if (coroutine.status task[2]) == "dead"
								Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
								break
				elseif (type task) == "function"
					Spawn task
			elseif (type t) == "function"
				while not t!
					wait 0.0625
				if (type task[2]) == "thread"
					Spawn ->
						coroutine.resume task[2]
						while wait 0.0625
							if (coroutine.status task[2]) == "dead"
								Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
								break
				elseif (type task) == "function"
					Spawn task

	startAll: =>
		for t,task in pairs @tSchedule
			spawn ->
				if (type t) == "table"
					nStartTime = os.date t
					while tick! < nStartTime
						wait 0.0625
					if (type task[2]) == "thread"
						Spawn ->
							coroutine.resume task[2]
							while wait 0.0625
								if (coroutine.status task[2]) == "dead"
									Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
									break
					elseif (type task) == "function"
						Spawn task
				elseif (type t) == "number"
					nStartTime = t
					while tick! < nStartTime
						wait 0.0625
					if (type task[2]) == "thread"
						Spawn ->
							coroutine.resume task[2]
							while wait 0.0625
								if (coroutine.status task[2]) == "dead"
									Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
									break
					elseif (type task) == "function"
						Spawn task
				elseif (type t) == "function"
					while not t!
						wait 0.0625
					if (type task[2]) == "thread"
						Spawn ->
							coroutine.resume task[2]
							while wait 0.0625
								if (coroutine.status task[2]) == "dead"
									Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
									break
					elseif (type task) == "function"
						Spawn task

return TaskScheduler