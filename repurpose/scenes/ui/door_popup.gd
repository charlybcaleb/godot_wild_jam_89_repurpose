extends Control

@export var name_txt: Label
@export var dmg_txt: Label
@export var hp_txt: Label
#@export var special_txt: Label

func _ready() -> void:
	add_to_group("door_popup")
	hide()

func update(room_data: RoomData):
	# update popup values, sprite, etc
	if room_data == null: print("ERROR: door popup room_data is null"); return
	name_txt.text = room_data.name
