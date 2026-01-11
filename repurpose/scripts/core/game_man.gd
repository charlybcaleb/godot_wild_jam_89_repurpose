extends Node
# system
var dun: Node = null
var camera: Node = null
# entities
var enemies: Array[Node2D]
var player: Node2D
var minions: Array[Node2D]
# queues
var attacks: Array[Attack]
var moves: Array[Move]
var coords_being_moved_to: Array[Vector2i]
# stats
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
	process_moves()
	process_attacks()

func enemy_tick():
	for e in enemies:
		e.tick(GlobalConstants.DELTA)

func minion_tick():
	for m in minions:
		m.tick(GlobalConstants.DELTA)

func player_moved():
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
		if m.speed > fastest.speed:
			fastest = m
			moves.push_front(moves.pop_at(moves.find(m)))
		if m.mover.hp <= 0:
			moves.pop_at(moves.find(m))
			continue
	# now do moves
	for m in moves:
		var _from_coord := m.from
		var to_coord := m.to
		var move_valid = true
		var mover := m.mover
		# check if to_coord is occupied
		if coords_being_moved_to.has(to_coord):
			move_valid = false
		if is_tile_occupied(to_coord): 
			move_valid = false; #print("queued move ignored, tile occupied!!!!!")
		else:
			print("TILE NOT OCCUPIED AT " + str(to_coord))
		if is_player_moving_to_tile(to_coord): move_valid = false
		if !move_valid:
			moves.pop_at(moves.find(m))
			moves_skipped += 1
			continue
		else:
			coords_being_moved_to.append(to_coord)
			mover.current_cell = to_coord
			mover.cur_pt += 1
			# the to_coord we receive is in tile space. tween_move works in global space.
			tween_move(mover, cell_to_pos(to_coord) + Vector2i((GlobalConstants.TILE_SIZE / 2.0),(GlobalConstants.TILE_SIZE / 2.0)))
			moves.pop_at(moves.find(m))
			moves_performed += 1
	if debug: print("moves performed: " + str(moves_performed) + ", moves skipped: " + str(moves_skipped))

func process_attacks():
	if attacks.size() == 0: return
	# first sort by speed
	var fastest := attacks[0]
	for a in attacks:
		if a.speed > fastest.speed:
			fastest = a
			attacks.push_front(attacks.pop_at(attacks.find(a)))
	# now do attacks
	for a in attacks:
		if a.attacker.hp <= 0:
			continue
		
		var die = a.dmg_die
		var rolls = a.dmg_rolls
		var damage := 0
		for r in rolls:
			damage += randi_range(1, die)
		attacks.pop_at(attacks.find(a))
		a.defender.take_damage(damage)
		# debug
		print(a.attacker.name + " " + a.attacker.data.name + " viciously attacked " + 
		a.defender.name + " " + a.defender.data.name + 
			" for " + str(damage) + " damage!")

func queue_attack(attack: Attack):
	attacks.append(attack)

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

func register_npc_death(npc: Node2D):
	if npc.is_in_group("enemy"):
		enemies.pop_at(enemies.find(npc))
		enemies_slain += 1
		print("enemy slain: " + npc.data.name)
	elif npc.is_in_group("minion"):
		minions.pop_at(minions.find(npc))
		minions_slain += 1
		print("minion slain: " + npc.data.name)

## INIT STUFF

func register_player(p: Node2D):
	p.setup(dun.astar_grid)
	player = p

func register_enemy(e: Node2D):
	e.setup(dun.astar_grid)
	enemies.append(e)

func RegisterDun(d: Node2D):
	dun = d

func SetupCam(cam: Node2D):
	camera = cam

func CamWorldPos() -> Vector2:
	return camera.global_position
