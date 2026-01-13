extends Area2D

var ui: Control
var enemy_popup: Control
var popup_offset:= Vector2(6,-72)

func _ready() -> void:
	await get_tree().process_frame
	ui = get_tree().get_first_node_in_group("ui")
	if ui == null: print("UI NOT FOUND")
	enemy_popup = get_tree().get_first_node_in_group("enemy_popup")
	if enemy_popup == null: print("enemy_popup NOT FOUND")

func _on_mouse_shape_entered(_shape_idx: int) -> void:
	# show popup
	enemy_popup.global_position = global_position + popup_offset
	enemy_popup.show()

func _on_mouse_shape_exited(shape_idx: int) -> void:
	# hide popup
	enemy_popup.hide()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# add enemy as soul to domain
		pass
	pass # Replace with function body.
