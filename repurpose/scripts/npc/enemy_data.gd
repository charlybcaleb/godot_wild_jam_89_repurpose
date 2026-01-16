class_name EnemyData
extends Resource

@export var name: String
@export var sprite_frames_path = "res://assets/sprites/characters/pelfen_frames.tres"
#stats
@export var hp := 9
# default = 1d4
@export var dmg_rolls := 1
@export var dmg_die := 4
@export var speed := 10
#special
@export var goblin_dance:= false
