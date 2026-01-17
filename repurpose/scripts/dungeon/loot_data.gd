class_name LootData
extends Resource

@export var name:= "dark_flower_loot" # used to get path and load node, and for tooltip
@export var loot_path_table: Dictionary[String, float]
@export var min_loot:= 1
@export var max_loot:= 3

func get_loot_path_weighted_random() -> String:
	# calculate sum
	var sum:= 0.0
	for key in loot_path_table:
		var weight = loot_path_table[key]
		sum += weight
	var r = randf_range(0.0, sum)
	var chosen_loot: String
	for key in loot_path_table:
		var weight = loot_path_table[key]
		if r < weight:
			chosen_loot = key
			return chosen_loot
		r -= weight
	print("loot_data: failed to weight choice loot, returning pelfen")
	return "null"
