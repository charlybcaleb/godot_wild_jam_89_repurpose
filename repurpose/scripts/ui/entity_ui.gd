extends Node2D

@export var entity: Node2D
@export var health_bar: ProgressBar

func set_health_bar(hp: float, max_hp: float):
	if hp == max_hp or hp <= 0.0: health_bar.hide(); return
	else: health_bar.show()
	health_bar.max_value = max_hp
	health_bar.value = hp

func setup(e: Node2D) -> void:
	entity = e
	entity.health_changed.connect(_on_entity_health_changed)
	set_health_bar(e.hp, e.max_hp)

func _on_entity_health_changed(new_hp, max_hp):
	set_health_bar(new_hp, max_hp)
