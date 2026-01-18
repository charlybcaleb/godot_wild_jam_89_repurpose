extends Control

@export var gems_text: Label

func _ready() -> void:
	#connect("mana_changed", Callable(self, "_on_mana_changed"))
	#for i in range(charge_icons.size()):
		#charge_icons[i].hide()
	GameMan.connect("gems_changed", Callable(self, "_on_gems_changed"))
	
func _on_gems_changed(amt: int):
	update_gems_ui(amt)
	
func update_gems_ui(x: int):
	gems_text.text = str(x)
