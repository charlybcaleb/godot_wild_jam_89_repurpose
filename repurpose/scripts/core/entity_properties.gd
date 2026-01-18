class_name EntityProperties
extends RefCounted

# lives on entities (player, minion, enemy..)
# uses for stats, so that stats can change throughout a run 
# (as opposed to enemy_data, which is runtime-readonly)

var name = "no_name"
var dmg_die: int
var dmg_rolls:= 1
var speed: int
var hp: int
var data: EnemyData
# set by this

func _init(enemy_data: EnemyData):
	data = enemy_data
	name = enemy_data.name
	dmg_die = enemy_data.dmg_die
	dmg_rolls = enemy_data.dmg_rolls
	speed = enemy_data.speed
	hp = enemy_data.hp
	# right now, queue attack from enemy fails on player if player inputs moves fast because current
	# cell of player is already changed.
