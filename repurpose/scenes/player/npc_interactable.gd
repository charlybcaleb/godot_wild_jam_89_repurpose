extends Area2D

var ui: Control
@onready var npc := get_parent()
var show_popup = false
var popup_offset:= Vector2(6,-72)
var is_corpse = false
var the_damned_waiting_for_redemption: Node2D

func _ready() -> void:
	await get_tree().process_frame
	ui = get_tree().get_first_node_in_group("ui")
	if ui == null: print("UI NOT FOUND")

func _on_mouse_shape_entered(_shape_idx: int) -> void:
	if ui == null: return
	ui.show_enemy_popup(npc)
	Domain.mouse_over_npc(npc)

func _on_mouse_shape_exited(_shape_idx: int) -> void:
	# hide popup
	if ui == null: return
	ui.show_enemy_popup(npc, false)
	Domain.mouse_over_npc(npc, true)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# add enemy as soul to domain
		if is_corpse:
			var valid = true
			GameMan.click_consumed = true
			if valid:
				send_soul_to_domain(the_damned_waiting_for_redemption)
				is_corpse = false
		else:
			if npc.is_in_group("minion"):
				if npc.secs_alive > 0.1: npc.die()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			GameMan.click_consumed = false

#func _process(delta: float) -> void:
	#if Input.is_action_just_released_by_event()

func become_corpse(_npc: Node2D, is_minion= false):
	is_corpse = true
	the_damned_waiting_for_redemption = _npc
	if is_minion:
		# if minion, do now, don't wait for mouse click. but, wait for anim.
		send_soul_to_domain(the_damned_waiting_for_redemption)

func send_soul_to_domain(_npc: Node2D):
	Domain.new_soul(_npc)
	ui.show_enemy_popup(npc, false)
	# delete corpse after delay to prevent instant summon lol FIXME: terrible.
	await get_tree().create_timer(0.300).timeout
	GameMan.remove_npc(npc)
