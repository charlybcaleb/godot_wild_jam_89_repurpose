extends Node

var dun: Node = null
var camera: Node = null

var enemies: Array[Node2D]

func RegisterDun(d: Node2D):
	dun = d

func SetupCam(cam: Node2D):
	camera = cam

func CamWorldPos() -> Vector2:
	return camera.global_position

func pos_to_cell(pos: Vector2):
	# FIXME: this must account for tweening. should prob round
	# to nearest cell. mnight be fucked up!
	return pos / GlobalConstants.TILE_SIZE

func register_enemy(e: Node2D):
	e.setup(dun.astar_grid)
	enemies.append(e)

func enemy_tick():
	for e in enemies:
		e.tick(GlobalConstants.DELTA)

func player_moved():
	enemy_tick()
