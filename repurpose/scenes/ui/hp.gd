extends Control

@export var hp_label: Label

func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	GameMan.player.connect("player_health_changed", Callable(self, "_on_player_health_changed"))

func _on_player_health_changed(health: int):
	hp_label.text = str(health)
