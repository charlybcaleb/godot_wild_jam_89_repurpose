extends Control

# enemy popup
var enemy_popup: Control
var enemy_popup_target: Node2D
var should_show_e_popup = false
var e_popup_offset:= Vector2(6,-72)
# door popup
var door_popup: Control
var door_popup_target: Node2D
var should_show_d_popup = false
var d_popup_offset:= Vector2(6,-72)
#map
@export var map_rooms: Array[Node] # 17 rooms total



#func link_map_rooms_in_column(col_start_index)

func _ready() -> void:
	add_to_group("ui")
	await get_tree().process_frame
	enemy_popup = get_tree().get_first_node_in_group("enemy_popup")
	door_popup = get_tree().get_first_node_in_group("door_popup")
	if enemy_popup == null: print("enemy_popup NOT FOUND")
	should_show_e_popup = false

func _process(_delta: float) -> void:
	if should_show_e_popup and !enemy_popup.visible:
		enemy_popup.show()
	if !should_show_e_popup and enemy_popup.visible:
		enemy_popup.hide()
	if should_show_d_popup and !door_popup.visible:
		door_popup.show()
	if !should_show_d_popup and door_popup.visible:
		door_popup.hide()

func show_enemy_popup(npc: Node2D, e= true):
	if e:
		enemy_popup_target = npc
		enemy_popup.global_position = npc.global_position + e_popup_offset
		should_show_e_popup = true
		enemy_popup.update(npc.data)
	else:
		if enemy_popup_target != npc:
			# without this, would end up turning off after enter when moving 
			# between two npcs quickly.
			return
		should_show_e_popup = false

func show_door_popup(door: Node2D, e= true):
	if e:
		door_popup_target = door
		door_popup.global_position = door.global_position + d_popup_offset
		should_show_d_popup = true
		door_popup.update(door.to_room_data)
	else:
		if door_popup_target != door:
			# without this, would end up turning off after enter when moving 
			# between two npcs quickly.
			return
		should_show_d_popup = false

############# DEPRECATED



## FIXME: this is terrible code and just made for jam it's so bad fuck myu life
#func link_map_rooms():
	#map_rooms.clear()
	#map_rooms = $Map.get_children()
	## room 0 column 0
	## if first room, make link to each in next column (mr[1,2,3])
	#var link_count = randi_range(3,3)
	#for lc in link_count:
		#var from_room = map_rooms[0]
		#var to_room = map_rooms[1+lc]
		#if !to_room.is_disabled:
			#var new_link = MapRoomLink.new(from_room, to_room)
			#map_rooms[0].add_link(new_link)
	## rooms 1-3 / column 1 
	#for mr in map_rooms:
		#mr.debug_label.text = str(map_rooms.find(mr))
	#
	#turn_off_next_col_rooms(1)
	#turn_off_next_col_rooms(4)
	#turn_off_next_col_rooms(7)
	#turn_off_next_col_rooms(10)
	#setup_map_room_column(1)
	#setup_map_room_column(4)
	#setup_map_room_column(7)
	#setup_map_room_column(10)
	#await get_tree().create_timer(0.8).timeout
	#prune_rooms_with_no_links()
#
#
#func setup_map_room_column(col_start_index: int):
	#await get_tree().process_frame
	#link_col_rooms_to_next_col(col_start_index, 3)
	#await get_tree().process_frame
	#link_adj_rooms_in_column(col_start_index)
#
#
#func turn_off_next_col_rooms(col_start_index: int):
	#var turn_off_a_room = randi_range(0,3)
	#if turn_off_a_room >= 1:
		#var random_mr_in_next_column = randi_range(col_start_index+3,col_start_index+5)
		#print(random_mr_in_next_column)
		#map_rooms[random_mr_in_next_column].set_disabled(true)
#
#func prune_rooms_with_no_fwd_links(col_start_index: int):
	#var mr_to_prune: Array[Node]
	#for i in map_rooms.size()-1:
		#if i > col_start_index and i < col_start_index+3:
			#var has_forward_link = false
			#for link in map_rooms[i].map_room_links:
				#if link.from.global_position.x < link.to.global_position.x:
					#has_forward_link = true
			#if has_forward_link == false:
				#mr_to_prune.append(map_rooms[i])
	#for mr in mr_to_prune:
		#for r in map_rooms:
			#for l in map_rooms[map_rooms.find(r)].get_links():
				#if l.to == mr:
					#r.remove_link(l)
					#print("link pruned")
		#map_rooms[map_rooms.find(mr)].set_disabled(true)
#
#func prune_rooms_with_no_links():
	#var mr_to_prune: Array[Node]
	#for mr in map_rooms:
		#var has_link = true
		#if !map_rooms[map_rooms.find(mr)].map_room_links.size() > 0:
				#has_link = false
		#if has_link == false:
			#mr_to_prune.append(map_rooms[map_rooms.find(mr)])
	#for mr in mr_to_prune:
		##for r in map_rooms:
			##for l in map_rooms[map_rooms.find(r)].get_links():
				##if l.to == mr:
					##r.remove_link(l)
					##print("link pruned")
		#map_rooms[map_rooms.find(mr)].set_disabled(true)
#
#func link_adj_rooms_in_column(col_start_index: int):
	#var mr_index = col_start_index
	#for i in range(3): # run 3 times
		#if mr_index >= col_start_index and mr_index < col_start_index+3:
			## for now, we link all adjacent column rooms.
			#var from_room = map_rooms[mr_index]
			#if from_room.is_disabled: return # don't start link from disabled room
			#var to_room = map_rooms[mr_index+1]
			#if to_room.is_disabled and mr_index != col_start_index+2:
				#to_room = map_rooms[map_rooms.find(to_room)+1]
			#var new_link = MapRoomLink.new(from_room, to_room)
			#map_rooms[mr_index].add_link(new_link)
		#mr_index += 1
#
#func link_col_rooms_to_next_col(col_start_index: int, forward_links: int):
	#var mr_index = col_start_index
	#var unpicked_from_rooms:= [col_start_index,col_start_index+1,col_start_index+2]
	## pick 1-2 random rooms to link forward
	#for i in (forward_links):
		#var from_room: int
		#var to_room: int
		#from_room = unpicked_from_rooms[randi_range(0,unpicked_from_rooms.size()-1)]
		#to_room = randi_range(col_start_index+3,col_start_index+5)
		#if map_rooms[to_room].is_disabled:
			## if disabled, go to other room in column
			#if to_room == col_start_index+3:
				#to_room = randi_range(col_start_index+4, col_start_index+5)
			#elif to_room == col_start_index+4:
				#var coin_flip = randi_range(0,1)
				#if coin_flip == 0:
					#to_room = col_start_index+3
				#else:
					#to_room = col_start_index+5
			#elif to_room == col_start_index+5:
				#var coin_flip = randi_range(0,1)
				#if coin_flip == 0:
					#to_room = col_start_index+3
				#else:
					#to_room = col_start_index+4
			#forward_links += 1
			#continue
		#unpicked_from_rooms.pop_at(unpicked_from_rooms.find(from_room))
		#var new_link = MapRoomLink.new(map_rooms[from_room], map_rooms[to_room])
		#map_rooms[mr_index].add_link(new_link)
		#mr_index+=1
