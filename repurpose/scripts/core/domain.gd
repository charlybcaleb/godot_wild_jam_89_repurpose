extends Node

var souls: Array[Node2D]

var soul_scene: PackedScene = preload("res://scenes/player/soul.tscn")

# domain spans from x 0 to 39 and y 15 to 21

func new_soul(corpse: Node2D):
	var soul = soul_scene.instantiate()
	soul.setup(corpse.data)
	# set soul to first available domain tile near center of domain
	pass

func find_empty_near_coord(coord: Vector2i):
	pass
