extends PanelContainer

# exists in ui scene.
# gets room data set by ui.gd
# connections built from ui.gd

@export var icon_sprite: TextureRect
@export var lines: Array[Line2D]
var room_data: RoomData
var center_offset = Vector2(32,32)
var is_disabled = false
var map_room_links: Array[MapRoomLink] 
@export var debug_label: Label

func set_icon_sprite(sprite: Texture2D):
	icon_sprite.texture = sprite

# set link 0 1 or 2 to another map_room
func add_link(map_room_link: MapRoomLink):
	map_room_links.append(map_room_link)
	lines[map_room_links.size()-1].clear_points()
	lines[map_room_links.size()-1].add_point(global_position+center_offset)
	lines[map_room_links.size()-1].add_point(map_room_link.to.global_position+center_offset)

func remove_link(map_room_link: MapRoomLink):
	if map_room_links.has(map_room_link):
		lines[map_room_links.find(map_room_link)].clear_points()
		map_room_links.pop_at(map_room_links.find(map_room_link))

func set_disabled(e= true):
	is_disabled = e
	hide()

func get_links() -> Array[MapRoomLink]:
	return map_room_links
