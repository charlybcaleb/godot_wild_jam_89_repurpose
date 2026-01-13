extends Area2D

func _on_mouse_shape_entered(shape_idx: int) -> void:
	# show popup
	pass

func _on_mouse_shape_exited(shape_idx: int) -> void:
	# hide popup
	pass # Replace with function body.

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# add enemy as soul to domain
		pass
	pass # Replace with function body.
