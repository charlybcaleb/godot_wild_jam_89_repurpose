class_name Move
extends RefCounted

var mover: Node2D
var from: Vector2i
var to: Vector2i
var speed: int
var if_invalid_find_nearest:= false
var invalid_retry_count = 0

func _init(_mover: Node2D, _from_pos: Vector2i, _to_pos: Vector2i, _speed: int, _if_invalid_find_nearest = false):
	mover = _mover
	from = _from_pos
	to = _to_pos
	speed = _speed
	if_invalid_find_nearest = _if_invalid_find_nearest
