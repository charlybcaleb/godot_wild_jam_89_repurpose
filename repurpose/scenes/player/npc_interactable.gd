extends Area2D

var ui: Control
var enemy_popup: Control
var popup_offset:= Vector2(6,-72)
var is_corpse = false
var the_damned_waiting_for_redemption: Node2D

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

func _on_mouse_shape_exited(_shape_idx: int) -> void:
	# hide popup
	enemy_popup.hide()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# add enemy as soul to domain
		if is_corpse:
			Domain.new_soul(the_damned_waiting_for_redemption)
			the_damned_waiting_for_redemption.hide()

func become_corpse(enemy: Node2D):
	is_corpse = true
	the_damned_waiting_for_redemption = enemy
