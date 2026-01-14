extends Node

var souls: Array[Node2D]
var spawn_moves: Array[Move]
var domain_center:= Vector2i(19,18)
var soul_scene: PackedScene = preload("res://scenes/player/soul.tscn")

# domain spans from x 0 to 39 and y 15 to 21

func new_soul(corpse: Node2D):
	var soul = soul_scene.instantiate()
	soul.setup(GameMan.dun.astar_grid, corpse.data) # FIXME: bad bad! GameMan should set this soul up!
	get_tree().get_root().add_child(soul)
	# set soul to first available tile near center of domain
	var free_tile = GameMan.get_free_tile_near(domain_center)
	var move = Move.new(
		soul, GameMan.pos_to_cell(soul.global_position), free_tile, 100, true)
	queue_soul_spawn_move(move)

func queue_soul_spawn_move(move: Move):
	spawn_moves.append(move)

func process_soul_spawn_moves():
	GameMan.tele_to_coord(spawn_moves[0].mover, spawn_moves[0].to, true)
	spawn_moves.remove_at(0)
	#print (" DOMAIN QUEUED MOVE TO:::::: " + str(free_tile))

func _process(_delta: float) -> void:
	if !spawn_moves.is_empty():
		process_soul_spawn_moves()
