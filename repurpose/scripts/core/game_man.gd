extends Node

var dun: Node = null
var camera: Node = null

var enemies: Array[Node2D]
var player: Node2D
var minions: Array[Node2D]

func pos_to_cell(pos: Vector2):
	# FIXME: this must account for tweening. should prob round
	# to nearest cell. mnight be fucked up!
	return pos / GlobalConstants.TILE_SIZE

func enemy_tick():
	for e in enemies:
		e.tick(GlobalConstants.DELTA)

func player_moved():
	enemy_tick()

func get_node_at_coord(coord: Vector2i) -> Node2D:
	for e in enemies:
		if e.current_cell == coord:
			return e
	for m in minions:
		if m.current_cell == coord:
			return m
	if player.current_cell == coord:
		return player
	return null

func is_tile_occupied(coord: Vector2i) -> bool:
	if get_node_at_coord(coord) == null:
		return false
	else:
		return true

func is_player_moving_to_tile(coord: Vector2i) -> bool:
	if player.target_cell == coord:
		return true
	else:
		return false

## INIT STUFF

func register_player(p: Node2D):
	p.setup(dun.astar_grid)
	player = p

func register_enemy(e: Node2D):
	e.setup(dun.astar_grid)
	enemies.append(e)

func RegisterDun(d: Node2D):
	dun = d

func SetupCam(cam: Node2D):
	camera = cam

func CamWorldPos() -> Vector2:
	return camera.global_position
