-- object_id_counter.moon

class object_id_counter
	@clazz_ids = {}
	@objID_by_clazzID = {}
	new: (strType) =>
		-- new class type ID, add it to index `clazz_ids`
		if not @@clazz_ids[strType]
			@@clazz_ids[strType] = #@@clazz_ids + 1
		-- Calculate the object id:
		if not @@objID_by_clazzID[@@clazz_ids[strType]]
			@@objID_by_clazzID[@@clazz_ids[strType]] = 1
			return @@clazz_ids[strType], @@objID_by_clazzID[@@clazz_ids[strType]]
		return @@clazz_ids[strType], @@objID_by_clazzID[@@clazz_ids[strType]] + 1
