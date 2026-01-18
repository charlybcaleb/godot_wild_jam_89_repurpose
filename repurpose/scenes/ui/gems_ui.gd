extends Control

@export var gems_label: Label

func _ready() -> void:
	GameMan.connect("gems_changed", Callable(self, "_on_gems_changed"))

func _on_gems_changed(amt: int):
	gems_label.text = str(amt)
