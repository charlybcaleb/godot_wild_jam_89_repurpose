extends Control

@export var name_txt: Label
@export var dmg_txt: Label
@export var hp_txt: Label
#@export var special_txt: Label

func _ready() -> void:
	add_to_group("enemy_popup")

func update(enemy_data: EnemyData):
	# update popup values, sprite, etc
	name_txt.text = enemy_data.name
	var dmg_string = str(enemy_data.dmgRolls) + "d" + str(enemy_data.dmgDie)
	dmg_txt.text = dmg_string
	hp_txt.text = str(enemy_data.hp)
