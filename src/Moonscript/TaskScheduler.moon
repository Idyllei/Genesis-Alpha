-- TaskScheduler.moon

class TaskScheduler
	new: (tSchedule, bAutoStart) =>
		-- /* 
		--  * tSchedule should be of the format:
		--  * {
		--  *	[Date]: {String Name, Thread task}
		--	*	[Timestamp]: {String Name, Thread task}
		--	*	[function]: Thread task
		--  * }
		--  */

		tNewSchedule = {}
		for t,task in pairs tSchedule
			if (((type t) == "table") or ((type t) == "number") or ((type t) == "function")) and (((type task) == "table") and ((type task[2]) == "thread") or ((type task) == "function"))
				tNewSchedule[t] = task

		@tSchedule = tNewSchedule

		if bAutoStart
			for t,task in pairs @tSchedule
				spawn ->
					if ((type t) == "table")
						nStartTime = os.date t
						while tick! < nStartTime
							wait 0.0625
						if ((type task[2]) == "thread")
							spawn ->
								coroutine.resume task[2]
								while wait 0.0625
									if (coroutine.status task[2]) == "dead"
										Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
										break
						elseif ((type task) == "function")
							spawn task
					elseif ((type t) == "number")
						nStartTime = t
						while tick! < nStartTime
							wait 0.0625
						if ((type task[2]) == "thread")
							spawn ->
								coroutine.resume task[2]
								while wait 0.0625
									if (coroutine.status task[2]) == "dead"
										Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
										break
						elseif ((type task) == "function")
							spawn task
					elseif ((type t) == "function")
						while not t!
							wait 0.0625
						if ((type task[2]) == "thread")
							spawn ->
								coroutine.resume task[2]
								while wait 0.0625
									if (coroutine.status task[2]) == "dead"
										Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
										break
						elseif ((type task) == "function")
							spawn task

	add: (t, task) =>
		if (((type t) == "table") or ((type t) == "number") or ((type t) == "function")) and (((type task) == "table") and ((type task[2]) == "thread") or ((type task) == "function"))
			tNewSchedule[t] = task
			if ((type t) == "table")
				nStartTime = os.date t
				while tick! < nStartTime
					wait 0.0625
				if ((type task[2]) == "thread")
					spawn ->
						coroutine.resume task[2]
						while wait 0.0625
							if (coroutine.status task[2]) == "dead"
								Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
								break
				elseif ((type task) == "function")
					spawn task
			elseif ((type t) == "number")
				nStartTime = t
				while tick! < nStartTime
					wait 0.0625
				if ((type task[2]) == "thread")
					spawn ->
						coroutine.resume task[2]
						while wait 0.0625
							if (coroutine.status task[2]) == "dead"
								Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
								break
				elseif ((type task) == "function")
					spawn task
			elseif ((type t) == "function")
				while not t!
					wait 0.0625
				if ((type task[2]) == "thread")
					spawn ->
						coroutine.resume task[2]
						while wait 0.0625
							if (coroutine.status task[2]) == "dead"
								Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
								break
				elseif ((type task) == "function")
					spawn task

	start: =>
		for t,task in pairs @tSchedule
			spawn ->
				if ((type t) == "table")
					nStartTime = os.date t
					while tick! < nStartTime
						wait 0.0625
					if ((type task[2]) == "thread")
						spawn ->
							coroutine.resume task[2]
							while wait 0.0625
								if (coroutine.status task[2]) == "dead"
									Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
									break
					elseif ((type task) == "function")
						spawn task
				elseif ((type t) == "number")
					nStartTime = t
					while tick! < nStartTime
						wait 0.0625
					if ((type task[2]) == "thread")
						spawn ->
							coroutine.resume task[2]
							while wait 0.0625
								if (coroutine.status task[2]) == "dead"
									Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
									break
					elseif ((type task) == "function")
						spawn task
				elseif ((type t) == "function")
					while not t!
						wait 0.0625
					if ((type task[2]) == "thread")
						spawn ->
							coroutine.resume task[2]
							while wait 0.0625
								if (coroutine.status task[2]) == "dead"
									Logger\logDebug "Task #{task[1]} has finished.", nil, "TaskScheduler"
									break
					elseif ((type task) == "function")
						spawn task

return TaskScheduler