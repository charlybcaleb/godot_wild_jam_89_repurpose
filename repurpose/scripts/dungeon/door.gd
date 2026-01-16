extends AnimatedSprite2D

var to_room_data: RoomData
var room: Node2D
var is_locked:= true
var is_open = false

func setup(rd: RoomData):
	if to_room_data != null: return
	to_room_data = rd

func player_knock_door():
	if is_locked: return
	get_child(0).show_popup()
	is_open = true
	play("open")
	
func close_and_lock():
	is_open = false
	is_locked = true
	play("lock")

func unlock():
	is_locked = false
	play("default")
