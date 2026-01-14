extends PanelContainer

# exists in ui scene.
# gets room data set by ui.gd
# connections built from ui.gd

@export var icon_sprite: TextureRect
var room_data: RoomData

func set_icon_sprite(sprite: Texture2D):
	icon_sprite.texture = sprite
