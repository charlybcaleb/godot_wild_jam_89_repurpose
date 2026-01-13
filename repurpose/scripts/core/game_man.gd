extends Node
# system
var dun: Node = null
var camera: Node = null
# entities
var enemies: Array[Node2D]
var player: Node2D
var minions: Array[Node2D]
var souls: Array[Node2D]
# queues
var attacks: Array[Attack]
var att_to_prune: Array[Attack]
var alrdy_attacked: Array[Node2D] # this is a bandaid fix for the jam.
var moves: Array[Move]
var moves_to_prune: Array[Move] # this is a bandaid fix for the jam.
var coords_being_moved_to: Array[Vector2i]
# stats
var turn := 0
var enemies_slain := 0
var minions_slain := 0

func pos_to_cell(pos: Vector2):
	# FIXME: this must account for tweening. should prob round
	# to nearest cell. mnight be fucked up! idk!
	return pos / GlobalConstants.TILE_SIZE

func cell_to_pos(cell: Vector2i):
	return cell * GlobalConstants.TILE_SIZE

func tick():
	enemy_tick()
	minion_tick()
	#await get_tree().create_timer(0.08).timeout
	process_moves()
	await get_tree().create_timer(GlobalConstants.MOVE_TWEEN_DURATION).timeout
	process_attacks(true) # process player attacks
	process_attacks(false) # process npc attacks
	# make corpses interactable etc
	process_corpses()
	turn += 1

func enemy_tick():
	for e in enemies:
		e.tick(GlobalConstants.DELTA)

func minion_tick():
	for m in minions:
		m.tick(GlobalConstants.DELTA)

func player_acted():
	#await get_tree().create_timer(GlobalConstants.MOVE_TWEEN_DURATION).timeout
	tick()

func queue_move(move: Move):
	if moves.has(move): print("move found in q, skipping. queue size: "+str(moves.size())); return
	moves.append(move)

func process_moves():
	if moves.size() == 0: return
	coords_being_moved_to.clear()
	# debug
	var debug := true
	var moves_performed = 0
	var moves_skipped = 0
	# sort by speed and prune dead
	var fastest := moves[0]
	for m in moves:
		#if m.speed > fastest.speed:
			#fastest = m
		if m.mover.is_in_group("player"):
			fastest = m
			moves.push_front(moves.pop_at(moves.find(fastest))) # FIXME: erm popping in le for loop?
		if m.mover.hp <= 0:
			moves_to_prune.append(m)
			continue
	# now do moves
	var player_moves_this_tick = 0
	for m in moves:
		var _from_coord := m.from
		var to_coord := m.to
		var move_valid = true
		var mover := m.mover
		# check if to_coord is occupied
		if coords_being_moved_to.has(to_coord):
			move_valid = false
		if is_tile_occupied(to_coord): 
			move_valid = false
		if m.mover.is_in_group("player") and player_moves_this_tick >= 1:
			move_valid = false
		#if is_player_moving_to_tile(to_coord): move_valid = false
		if !move_valid:
			moves_to_prune.append(m)
			moves_skipped += 1
			continue
		else:
			if mover.is_in_group("player"):
				player_moves_this_tick += 1
			coords_being_moved_to.append(to_coord)
			mover.current_cell = to_coord
			mover.cur_pt += 1
			# the to_coord we receive is in tile space. tween_move works in global space.
			tween_move(mover, cell_to_pos(to_coord) + Vector2i((GlobalConstants.TILE_SIZE / 2.0),(GlobalConstants.TILE_SIZE / 2.0)))
			moves_to_prune.append(m)
			moves_performed += 1
	# cleanup
	for m in moves_to_prune:
		moves.pop_at(moves.find(m))
	if debug: print("moves performed: " + str(moves_performed) + ", moves skipped: " + str(moves_skipped))

func process_attacks(player_mode: bool):
	if attacks.size() == 0: return
	att_to_prune.clear()
	alrdy_attacked.clear()
	# sort by speed, filter
	var fastest := attacks[0]
	for a in attacks:
		if a.speed > fastest.speed:
			fastest = a
	attacks.push_front(fastest)

	# now do attacks
	for a in attacks:
		# prune invalid
		if a.attacker.hp <= 0:
			att_to_prune.append(a)
			continue
		if a.turn != get_turn():
			att_to_prune.append(a)
			continue
		if abs(a.attacker.current_cell.x - a.defender.current_cell.x) > 1 or \
		abs(a.attacker.current_cell.y - a.defender.current_cell.y) > 1:
			att_to_prune.append(a)
			continue
		if alrdy_attacked.has(a.attacker):
			att_to_prune.append(a)
			continue
		# skip according to mode
		if player_mode and !a.attacker.is_in_group("player"):
			continue
		if !player_mode and a.attacker.is_in_group("player"):
			continue
		# do attack
		var die = a.dmg_die
		var rolls = a.dmg_rolls
		var damage := 0
		for r in rolls:
			damage += randi_range(1, die)
		a.defender.take_damage(damage)
		attacks.pop_at(attacks.find(a))
		alrdy_attacked.append(a.attacker)
		# debug
		print(a.attacker.name + " " + a.attacker.data.name + " viciously attacked " + 
		a.defender.name + " " + a.defender.data.name + 
			" for " + str(damage) + " damage!" + str(a.from) + " to " +
			str(a.to) + ". TURN " + str(get_turn()))
	# now cleanup attacks
	for a in att_to_prune:
		attacks.pop_at(attacks.find(a))


func queue_attack(attack: Attack):
	var a := attack
	var valid := true
	var aq_log = ""
	if a.attacker.hp <= 0:
		valid = false; aq_log += "att hp 0, "
	if abs(a.from.x - a.to.x) > 2 or \
		abs(a.from.y - a.to.y) > 2:
		valid = false; aq_log += "att too far, "
	if a.turn != get_turn():
		valid = false; aq_log += "att expired, "
	if valid: attacks.append(attack)
	else:
		print("QUEUE_ATTACK: failed because " + aq_log)

func process_corpses():
	for e in enemies:
		pass
		#if e.is_corpse:
			

func tween_move(mover: Node2D, to: Vector2):
	var dur = GlobalConstants.MOVE_TWEEN_DURATION
	var tween = create_tween()
	tween.tween_property(mover, "global_position", to, dur) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

## HELPERS AND REGISTRATION

func get_node_at_coord(coord: Vector2i) -> Node2D:
	for e in enemies:
		if e.current_cell == coord:
			return e
	for m in minions:
		if m.current_cell == coord:
			return m
	for s in souls:
		if s.current_cell == coord:
			return s
	if player.current_cell == coord:
		return player
	return null

func is_tile_occupied(coord: Vector2i) -> bool:
	if get_node_at_coord(coord) == null:
		return false
	else:
		return true

func is_player_moving_to_tile(coord: Vector2i) -> bool:
	if player.target_cell == coord:
		return true
	else:
		return false

func is_tile_blocked(coord: Vector2i) -> bool:
	var blocked = false
	if dun.is_cell_obstacle(coord):
		blocked = true
	if is_tile_occupied(coord):
		blocked = true
	return blocked

#func tele_to_coord(entity: Node2D, coord: Vector2i):
	#entity.global_position = coord

func get_free_tile_near(start_coord: Vector2i) -> Vector2i:
	var queue: Array[Vector2i]
	var visited: Array[Vector2i]
	var max_steps:= 20
	var current_step:= 0
	
	queue.append(start_coord)
	visited.append(start_coord)
	while !queue.is_empty() and current_step <= max_steps:
		var current_coord = queue.pop_front()
		if !is_tile_blocked(current_coord):
			return current_coord
		
		# free tile not found, continue
		visited.append(current_coord)
		var left_n = current_coord + Vector2i(-1,0)
		var right_n = current_coord + Vector2i(1,0)
		var up_n = current_coord + Vector2i(0,-1)
		var down_n = current_coord + Vector2i(0,1)
		var neighbors: Array[Vector2i]
		neighbors.append(left_n); neighbors.append(right_n); neighbors.append(up_n); neighbors.append(down_n);
		for n in neighbors:
			if !visited.has(n):
				queue.append(n)
		current_step += 1
	# if none found, return invalid coord
	return Vector2i(999,999)

func register_npc_death(npc: Node2D):
	if npc.is_in_group("enemy"):
		enemies.pop_at(enemies.find(npc))
		enemies_slain += 1
		print("enemy slain: " + npc.data.name)
	elif npc.is_in_group("minion"):
		minions.pop_at(minions.find(npc))
		minions_slain += 1
		print("minion slain: " + npc.data.name)

func get_turn() -> int:
	return turn

## INIT STUFF

func register_player(p: Node2D):
	p.setup(dun.astar_grid)
	player = p

func register_enemy(e: Node2D):
	e.setup(dun.astar_grid)
	enemies.append(e)

func register_minion(m: Node2D):
	m.setup(dun.astar_grid)
	minions.append(m)

func register_soul(s: Node2D):
	souls.append(s)

func register_dun(d: Node2D):
	dun = d

func SetupCam(cam: Node2D):
	camera = cam

func CamWorldPos() -> Vector2:
	return camera.global_position
