extends Control

@export var name_txt: Label
@export var dmg_txt: Label
@export var hp_txt: Label
#@export var special_txt: Label

func _ready() -> void:
	add_to_group("door_popup")

func update(room_data: RoomData):
	# update popup values, sprite, etc
	name_txt.text = room_data.name
