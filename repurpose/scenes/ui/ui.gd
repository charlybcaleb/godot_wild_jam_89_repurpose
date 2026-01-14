extends Control

#popups
var enemy_popup: Control
var enemy_popup_target: Node2D
var show_popup = false
var popup_offset:= Vector2(6,-72)
#map
@export var map_rooms: Array[Control] # 17 rooms total

# FIXME: this is terrible code and just made for jam it's so bad
func link_map_rooms():
	var c1_link_count = 0
	for mr in map_rooms:
		var mr_index = map_rooms.find(mr)
		# room 0 column 0
		if mr_index == 0:
			# if first room, make link to each in next column (mr[1,2,3])
			var link_count = randi_range(3,3)
			for lc in link_count:
				var to_room = map_rooms[1+lc]
				if !to_room.is_disabled:
					mr.set_link(lc, map_rooms[1+lc])
		# rooms 1-3 column 1 set here
		if mr_index == 1:
			# first turn off 0-1 random rooms in next column
			var turn_off_a_room = randi_range(0,1)
			if turn_off_a_room == 1:
				var random_mr_in_next_column = randi_range(4,6)
				map_rooms[random_mr_in_next_column].set_disabled(true)
		if mr_index > 0 and mr_index < 3:
			# for now, we link all adjacent column rooms.
			var from = map_rooms[mr_index]
			if from.is_disabled: continue # don't start link from disabled room
			var to = map_rooms[mr_index+1]
			if to.is_disabled and mr_index != 3:
				to = map_rooms[to+1]
			map_rooms[mr_index].set_link(0, to)

func _ready() -> void:
	add_to_group("ui")
	await get_tree().process_frame
	enemy_popup = get_tree().get_first_node_in_group("enemy_popup")
	if enemy_popup == null: print("enemy_popup NOT FOUND")
	show_popup = false
	link_map_rooms()

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
