extends Resource
class_name BaseData

export(Array, Dictionary) var data_table

var level : int = 1

func get_level() -> int:
	return level

func reset_level() -> void:
	level = 1

func get_level_data(_level:int=level) -> Dictionary:
	if level_is_max():
		return data_table[_level-1]
	else:
		return data_table[_level]

func update_level() -> void:
	if not level_is_max():
		level += 1

func level_is_max() -> bool:
	return level >= len(data_table)

