extends Node

var dun: Node = null
var camera: Node = null

var enemies: Array[Node2D]
var player: Node2D
var minions: Array[Node2D]
var attacks: Array[Attack]

var enemies_slain := 0
var minions_slain := 0

func pos_to_cell(pos: Vector2):
	# FIXME: this must account for tweening. should prob round
	# to nearest cell. mnight be fucked up! idk!
	return pos / GlobalConstants.TILE_SIZE

func tick():
	enemy_tick()
	minion_tick()
	process_attacks()

func enemy_tick():
	for e in enemies:
		e.tick(GlobalConstants.DELTA)

func minion_tick():
	for m in minions:
		m.tick(GlobalConstants.DELTA)

func player_moved():
	tick()

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
		a.defender.take_damage(damage)
		print(a.attacker.name + " " + a.attacker.data.name + " viciously attacked " + 
		a.defender.name + " " + a.defender.data.name + 
			" for " + str(damage) + " damage!")
		attacks.pop_at(attacks.find(a))

func queue_attack(attack: Attack):
	attacks.append(attack)

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
