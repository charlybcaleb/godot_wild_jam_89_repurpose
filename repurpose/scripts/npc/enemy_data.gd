class_name EnemyData
extends Resource

@export var name: String
@export var spritePath: String
#stats
@export var hp := 9
# default = 1d4
@export var dmgRolls := 1
@export var dmgDie := 4
@export var speed := 10
#special
@export var goblin_dance:= false
