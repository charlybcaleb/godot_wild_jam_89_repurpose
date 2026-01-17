extends Area2D

var ui: Control
@onready var door := get_parent()
var popup_offset:= Vector2(6,-72)

func _ready() -> void:
	await get_tree().process_frame
	ui = get_tree().get_first_node_in_group("ui")
	if ui == null: print("DOOR: UI NOT FOUND")

func _on_mouse_shape_entered(_shape_idx: int) -> void:
	if door == null or ui == null: return
	ui.show_door_popup(door)

func _on_mouse_shape_exited(_shape_idx: int) -> void:
	# hide popup
	if door == null or ui == null: return
	ui.show_door_popup(door, false)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		pass

func show_popup():
	if door == null: return
	ui.show_door_popup(door)

func hide_popup():
	if door == null: return
	ui.show_door_popup(door, false)

#func _process(delta: float) -> void:
	#if Input.is_action_just_released_by_event()

#func become_corpse(_door: Node2D, is_minion= false):
	#is_corpse = true
	#the_damned_waiting_for_redemption = _door
	#if is_minion:
		## if minion, do now, don't wait for mouse click. but, wait for anim.
		#send_soul_to_domain(the_damned_waiting_for_redemption)
#
#func send_soul_to_domain(_door: Node2D):
	#Domain.new_soul(_door)
	#ui.show_door_popup(door, false)
	## delete corpse after delay to prevent instant summon lol FIXME: terrible.
	#await get_tree().create_timer(0.300).timeout
	#door.queue_free()
