extends Control

var enemy_popup: Control
var enemy_popup_target: Node2D
var show_popup = false
var popup_offset:= Vector2(6,-72)

func _ready() -> void:
	add_to_group("ui")
	await get_tree().process_frame
	enemy_popup = get_tree().get_first_node_in_group("enemy_popup")
	if enemy_popup == null: print("enemy_popup NOT FOUND")
	show_popup = false

func _process(_delta: float) -> void:
	if show_popup and !enemy_popup.visible:
		enemy_popup.show()
	if !show_popup and enemy_popup.visible:
		enemy_popup.hide()

func show_enemy_popup(npc: Node2D, e= true):
	if e:
		enemy_popup_target = npc
		enemy_popup.global_position = npc.global_position + popup_offset
		show_popup = true
		enemy_popup.update(npc.data)
	else:
		if enemy_popup_target != npc:
			# without this, would end up turning off after enter when moving 
			# between two npcs quickly.
			return
		show_popup = false
