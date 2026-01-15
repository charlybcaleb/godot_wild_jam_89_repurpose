class_name MapRoomLink
extends RefCounted

var from: Control
var to: Control
var slot = 0

func _init(_from_mr: Control, _to_mr: Control, _slot = 0):
	from = _from_mr
	to = _to_mr
	slot = _slot
