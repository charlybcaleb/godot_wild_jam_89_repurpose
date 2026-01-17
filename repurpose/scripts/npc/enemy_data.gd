class_name EnemyData
extends Resource

@export var name: String
@export var sprite_frames_path = "res://assets/sprites/characters/pelfen_frames.tres"
@export var loot_data_path = "res://assets/resources/loot_data/5_50_gem_loot_data.tres"
#stats
@export var hp := 9
# default = 1d4
@export var dmg_rolls := 1
@export var dmg_die := 4
@export var speed := 10
#special
@export var goblin_dance:= false

func get_frames_path() -> String:
	var directory = "res://assets/sprites/characters/"
	var file_name = name.to_lower()
	var suffix = "_frames.tres"
	return directory + file_name + suffix

func get_necrofied_frames_path() -> String:
	var directory = "res://assets/sprites/characters/"
	var file_name = name.to_lower()
	var suffix = "_necro_frames.tres"
	return directory + file_name + suffix
