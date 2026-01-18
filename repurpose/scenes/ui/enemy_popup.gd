extends Control

@export var name_txt: Label
@export var dmg_txt: Label
@export var hp_txt: Label
@export var cost_txt: Label
@export var icon_rect: TextureRect
#@export var special_txt: Label

func _ready() -> void:
	add_to_group("enemy_popup")

func update(entity_props: EntityProperties):
	# update popup values, sprite, etc
	name_txt.text = entity_props.name
	var dmg_string = str(entity_props.dmg_rolls) + "d" + str(entity_props.dmg_die)
	dmg_txt.text = dmg_string
	hp_txt.text = str(entity_props.hp)
	icon_rect.texture = load(entity_props.data.get_icon_path())
	cost_txt.text = str(entity_props.data.cost)
