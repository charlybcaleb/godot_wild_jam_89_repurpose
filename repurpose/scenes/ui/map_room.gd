extends PanelContainer

# exists in ui scene.
# gets room data set by ui.gd
# connections built from ui.gd

@export var icon_sprite: TextureRect
@export var lines: Array[Line2D]
var room_data: RoomData
var center_offset = Vector2(32,32)
var is_disabled = false

func set_icon_sprite(sprite: Texture2D):
	icon_sprite.texture = sprite

# set link 0 1 or 2 to another map_room
func set_link(link_slot: int, to_room: Control):
	lines[link_slot].clear_points()
	lines[link_slot].add_point(global_position+center_offset, 0)
	lines[link_slot].add_point(to_room.global_position+center_offset, 1)

func set_disabled(e= true):
	is_disabled = e
