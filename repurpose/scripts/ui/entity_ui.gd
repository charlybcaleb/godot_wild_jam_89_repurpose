extends Node2D

@export var entity: Node2D
@export var health_bar: ProgressBar
@export var minion_fill_color: Color
@export var minion_bg_color: Color
@export var enemy_fill_color: Color
@export var enemy_bg_color: Color

func set_health_bar(hp: float, max_hp: float):
	if hp == max_hp or hp <= 0.0: health_bar.hide(); return
	else: health_bar.show()
	health_bar.max_value = max_hp
	health_bar.value = hp

func setup(e: Node2D) -> void:
	entity = e
	entity.health_changed.connect(_on_entity_health_changed)
	print ("e type: " + str(e.entity_type))
	if e.entity_type == GlobalConstants.EntityType.MINION:
		print("MINION!!!!!!!!!!!!!!!!")
		var fill_sbox = health_bar.get_theme_stylebox("fill")
		fill_sbox.bg_color = minion_fill_color
		var bg_sbox = health_bar.get_theme_stylebox("background")
		bg_sbox.bg_color = minion_bg_color
	else:
		print("!!!!!!!!NOT MINIONT!!!!!!!!!!!!!!!!")
		var fill_sbox = health_bar.get_theme_stylebox("fill")
		fill_sbox.bg_color = enemy_fill_color
		var bg_sbox = health_bar.get_theme_stylebox("background")
		bg_sbox.bg_color = enemy_bg_color
	
	set_health_bar(e.hp, e.max_hp)

func _on_entity_health_changed(new_hp, max_hp):
	set_health_bar(new_hp, max_hp)
