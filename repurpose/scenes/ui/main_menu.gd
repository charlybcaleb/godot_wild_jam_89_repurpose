extends Control

var menu_open = true

func _ready() -> void:
	if menu_open == false: return
	show()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("lmb"):
		# check props
		if menu_open:
			hide()
			menu_open = false
