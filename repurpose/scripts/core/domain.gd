extends Node2D

var spawn_moves: Array[Move]
var domain_center:= Vector2i(19,18)
var soul_scene: PackedScene = preload("res://scenes/player/soul.tscn")
var npc_at_mouse: Node2D

# domain spans from x 0 to 39 and y 15 to 21

func new_soul(corpse: Node2D):
	var soul = soul_scene.instantiate()
	soul.setup(GameMan.dun.astar_grid, corpse.data) # FIXME: bad bad! GameMan should set this soul up!
	get_tree().get_root().add_child(soul)
	# set soul to first available tile near center of domain
	var free_tile = GameMan.get_free_tile_near(domain_center)
	var move = Move.new(
		soul, GameMan.pos_to_cell(soul.global_position), free_tile, 100, true)
	queue_soul_spawn_move(move)

func queue_soul_spawn_move(move: Move):
	spawn_moves.append(move)

func process_soul_spawn_moves():
	GameMan.tele_to_coord(spawn_moves[0].mover, spawn_moves[0].to, true)
	spawn_moves.remove_at(0)
	#print (" DOMAIN QUEUED MOVE TO:::::: " + str(free_tile))

func _process(_delta: float) -> void:
	if !spawn_moves.is_empty():
		process_soul_spawn_moves()
	if Input.is_action_just_pressed("lmb"):
		# if there is a corpse at this position, do not summon.
		if npc_at_mouse:
			if npc_at_mouse.hp <= 0:
				return
		if !GameMan.souls.is_empty():
			var soul = GameMan.souls[0]
			var click_coord = GameMan.pos_to_cell(get_global_mouse_position())
			var valid = true
			if GameMan.click_consumed:
				valid = false
			print("SUMMON CLICK AT COORD " + str(click_coord))
			if GameMan.is_tile_blocked(click_coord):
				valid = false
			if valid: 
				summon_at(click_coord, soul)
	if Input.is_action_just_pressed("debug"):
		var click_coord = round(GameMan.pos_to_cell(get_global_mouse_position()))
		print("DEBUG CLICK AT COORD " + str(click_coord))

## spawns first unassigned soul in at coord as minion, unless other soul is provided.
func summon_at(coord: Vector2i, soul: Node2D = null):
	GameMan.spawn_npc(soul.data, coord, soul)
	soul.queue_free()

# called by npc_interactable twice, with the latter removing the npc after a delay,
# to prevent race condition
func mouse_over_npc(npc: Node2D, clear= false):
	if !clear:
		npc_at_mouse = npc
		return
	if clear and npc == npc_at_mouse:
		await get_tree().create_timer(0.050).timeout
		npc_at_mouse = null
		print("no mo npc!!!!!!!")

#func _input(event: InputEvent) -> void:
	## if left click, summon_at pos
	#if event is InputEventMouseButton and !GameMan.click_consumed:
		#if !GameMan.souls.is_empty():
			#var soul = GameMan.souls[0]
			#var click_coord = GameMan.pos_to_cell(get_global_mouse_position())
			#var valid_coord = true
			#if GameMan.is_tile_blocked(click_coord):
				#valid_coord = false
			#if valid_coord: 
				#summon_at(click_coord, soul)
