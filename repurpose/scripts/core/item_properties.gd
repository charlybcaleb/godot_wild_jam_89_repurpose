class_name ItemProperties
extends RefCounted

var name = "no_name"
var quantity = 1

# set by this

func _init(enemy_data: EnemyData):
	name = enemy_data.name
