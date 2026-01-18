extends Control

@export var charge_icons: Array[Sprite2D]

func _ready() -> void:
	#connect("mana_changed", Callable(self, "_on_mana_changed"))
	for i in range(charge_icons.size()):
		charge_icons[i].hide()
	GameMan.connect("mana_changed", Callable(self, "_on_mana_changed"))
func _on_mana_changed(amt: int):
	show_x_charge_icons(amt)
	
func show_x_charge_icons(x: int):
	for i in range(charge_icons.size()):
		if i >= x:
			charge_icons[i].hide()
		else:
			charge_icons[i].show()
