extends BaseMinion

@export var soul_data: SoulData
var soul_state:= SoulState.IDLE
@export var mouse_follow_speed:= 50.0

enum SoulState { IDLE, CHANNEL, WORK, HELD }

func _ready(): 
	GameMan.register_soul(self)
	add_to_group("soul")
	set_physics_process(false)

# called by Domain but should be called by GameMAn
func setup(_grid: AStarGrid2D, _data: EnemyData = null):
	super.setup(_grid, _data)

func _process(delta: float) -> void:
	if soul_state == SoulState.HELD:
		var mouse_pos = Vector2.ZERO
		mouse_pos = get_global_mouse_position()
		global_position = global_position.lerp(mouse_pos, delta * mouse_follow_speed)

## called by GameMan when player moves
func tick(_delta: float) -> void:
	if hp <= 0: return
	## MOVEMENT
	# FIXME: this is ratchet af, but maybe it will work to make enemies move after player and not overlap???
	await get_tree().create_timer(0.08).timeout
	if get_target() == null: return
	if target == null or target.hp <= 0:
		set_target(get_target())
		if target: print("enemy targeted: " + target.name)
	if target != null:
		var tpos = Vector2i(GameMan.pos_to_cell(target.global_position))
		if tpos != tpos+Vector2i.UP: # FIXME: lol i turned this check off. cuz it was making enemies not move.!
			move_pts = grid.get_point_path(current_cell, tpos)
			var path_blocked = false
			for mp in move_pts:
				var mp_coord = (GameMan.pos_to_cell(mp))
				print("MINI PATH PT: " + str(mp_coord))
				# check if any points aside from start and end are blocked
				if move_pts.find(mp) != move_pts.size()-1 and \
				move_pts.find(mp) != 1 and \
				move_pts.find(mp) != 0:
					if GameMan.is_tile_blocked(mp_coord, false):
						path_blocked = true
						print("MINI PATH BLOCKED: " + str(mp_coord))
			# offset move_pts path by half the size of our tile size to get center
			# this must be done before movement. FIXME: this sucks
			move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
			# if path blocked, wander 1 tile instead and retry
			if path_blocked:
				var dir_to_target = Vector2(tpos - current_cell).normalized()
				#var one_tile_closer = current_cell + Vector2i(dir_to_target)
				var two_tiles_closer = current_cell + Vector2i(dir_to_target*2)
				move_pts = grid.get_point_path(current_cell, \
				GameMan.get_free_tile_near(GameMan.get_random_neighbor_tile(two_tiles_closer)))
				move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
			target_cell = tpos
			do_move()
			recalc_path()
	## ACTIONS
	if target != null:
		var att = Attack.new(self, target, entity_props.dmg_die, entity_props.dmg_rolls, entity_props.speed)
		GameMan.queue_attack(att)
		print("MINI QUEUED ATTACK!!!")
		return

func get_target() -> Node2D:
	var workables = get_tree().get_nodes_in_group("workable")
	# prune those not in domain 
	var to_prune = []
	for w in workables:
		if !GameMan.is_tile_in_domain(GameMan.pos_to_cell(w.global_position)):
			to_prune.append(w)
	for w in to_prune:
		workables.pop_at((workables.find(w)))
	
	var closest: Node2D
	var lowest_dist := 99.0
	if workables.size() > 0:
		for w in workables:
			var dist = GameMan.player.current_cell.distance_to(w.current_cell)
			if w.hp > 0 and dist < lowest_dist:
				lowest_dist = dist
				closest = w
		return closest
	else: return null


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton  \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed():
		if soul_state != SoulState.HELD:
			soul_state = SoulState.HELD
		else:
			#todo: check and see if over valid tile.
			soul_state = SoulState.IDLE
