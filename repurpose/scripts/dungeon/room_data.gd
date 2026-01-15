class_name RoomData
extends Resource

@export var name:= "tomb" # used to get path and load node, and for tooltip
@export var room_scene_path:= ""
@export var spawn_weight := 1 # weight to appear as next room option
@export var enemy_table: Dictionary[EnemyData, float] # enemy, weight
@export var min_enemies:= 0
@export var max_enemies:= 0
# soul room stuff
#@export var resource := GlobalConstants.ResourceType.MP
#@export var wu_needed := 3 # each soul nets 1 wu per tick
#@export var output_amt := 1
func get_enemy_weighted_random() -> EnemyData:
	# calculate sum
	var sum:= 0.0
	for key in enemy_table:
		var weight = enemy_table[key]
		sum += weight
	var r = randf_range(0.0, sum)
	var chosen_enemy: EnemyData
	for key in enemy_table:
		var weight = enemy_table[key]
		if r < weight:
			chosen_enemy = key
	return chosen_enemy
