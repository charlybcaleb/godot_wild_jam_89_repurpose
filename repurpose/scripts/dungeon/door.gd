extends AnimatedSprite2D

var room_data: RoomData
var room: Node2D

func setup(rd: RoomData):
	room_data = rd

func player_knock_door():
	get_child(0).show_popup()
