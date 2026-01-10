extends Node

var dun: Node = null
var camera: Node = null

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
