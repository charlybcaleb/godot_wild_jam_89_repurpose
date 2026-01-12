extends CharacterBody2D

@export var hp:= 9
@export var data: EnemyData

# nav / movement
var grid: AStarGrid2D
var current_cell: Vector2i
var cur_pt: int
var target_cell: Vector2i
var move_pts: Array
# move / attack target
var target: Vector2 = Vector2.ZERO

# this prevents pseudo-diagonal and super fast instant turns. might remove idk. i think diag is unintuitive.
var move_cooldown := GlobalConstants.MOVE_TWEEN_DURATION
var time_since_last_move := 99.99
var queued_move: Vector2i

# viz
var facing_right: bool

func _ready() -> void:
	GameMan.register_player(self)
	add_to_group("player")
	hp = data.hp

func setup(_grid: AStarGrid2D):
	grid = _grid
	current_cell = GameMan.pos_to_cell(global_position)
	target_cell = current_cell

func _physics_process(delta: float) -> void:
	if time_since_last_move < move_cooldown:
		time_since_last_move += delta
	if queued_move != Vector2i.ZERO and time_since_last_move >= move_cooldown:
		try_move(queued_move, true)
		queued_move = Vector2i.ZERO
		print("DID QUEUED MOVE!!!")

enum InputDir { LEFT, RIGHT, UP, DOWN, NONE, }

func _input(event: InputEvent):
	if event is InputEventMouseMotion: return
	
	var input_dir := InputDir.NONE
	var target_pos = current_cell
	if Input.is_action_just_pressed("move_left"):
		input_dir = InputDir.LEFT
	elif Input.is_action_just_pressed("move_right"):
		input_dir = InputDir.RIGHT
	elif Input.is_action_just_pressed("move_up"):
		input_dir = InputDir.UP
	elif Input.is_action_just_pressed("move_down"):
		input_dir = InputDir.DOWN
	else:
		return
	
	if input_dir == InputDir.LEFT:
		target_pos.x = current_cell.x - 1
	elif input_dir == InputDir.RIGHT:
		target_pos.x = current_cell.x + 1
	elif input_dir == InputDir.UP:
		target_pos.y = current_cell.y - 1
	elif input_dir == InputDir.DOWN:
		target_pos.y = current_cell.y + 1
	
	# check if occupied. if occ by enemy, queue attack. if occ by else, skip input.
	var occupant := GameMan.get_node_at_coord(target_pos)
	if occupant:
		if occupant.is_in_group("enemy"):
			print("--------PLAYER ATTACK QUEUEING from: " + str(current_cell) + " to " + str((occupant.current_cell)))
			var att = Attack.new(self, occupant, data.dmgDie, data.dmgRolls, data.speed)
			GameMan.queue_attack(att)
			GameMan.player_moved()
			return
		else:
			return
	
	# queued move target is currently player pos and occuring every time player moves.
	if time_since_last_move < move_cooldown:
		if queued_move == Vector2i.ZERO:
			queued_move = target_pos
		print("TRIED TO MOVE, CAN'T CUZ COOLDOWN TIMER AT: " + str(time_since_last_move))
		return

	try_move(target_pos, false)

## called from inputting a direction. tile coord pos.
func try_move(target_pos: Vector2i, was_queued: bool):
	target = target_pos
	if GameMan.is_tile_occupied(target):
		print ("player can't move, tile occupied")
		return
	#print("move target: " + str(target))
	move_tick()
	if !was_queued: time_since_last_move = 0.0

# enemy equiv is tick()
func move_tick() -> void:
	var tpos = Vector2i(target)
	if tpos != target_cell:
		move_pts = grid.get_point_path(current_cell, tpos)
		# offset move_pts path by half the size of our tile size to get center
		move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
		target_cell = tpos
		do_move()
		GameMan.player_moved()
		recalc_path()

func do_move():
	#print("move_pts size: " + str(move_pts.size()))
	if move_pts.is_empty(): print("move esa empty!"); return 
	cur_pt = 0;
	
	# check target range. if adjacent, do combat
	#if target != null:
		#var dist = GameMan.pos_to_cell(global_position).distance_to(
			#GameMan.pos_to_cell(target))
		#print("dist: " + str(dist))
		#if dist < 2.0:
			#print("arrived")
			## probably flag for combat, then gman will do combat after TWEEN_DURATION delay
			#return

	if cur_pt == move_pts.size() -1:
		# FIXME: do arrival logic
		print("PLAYER ARRIVED")
		current_cell = GameMan.pos_to_cell(global_position)
		tween_move(move_pts[-1])
		# viz
		$PathPreviz.points = []; 
		pass
	else:
		#global_position = move_pts[cur_pt+1]
		tween_move(move_pts[cur_pt+1])
		current_cell = GameMan.pos_to_cell(move_pts[cur_pt+1])
		cur_pt += 1
		# viz
		play_move_anim(true)
		play_anim_delayed("default", GlobalConstants.MOVE_TWEEN_DURATION)


func tween_move(to: Vector2):
	var dur = GlobalConstants.MOVE_TWEEN_DURATION
	var tween = create_tween()
	tween.tween_property(self, "global_position", to, dur) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

func take_damage(damage: float):
	damage = int(round(damage))
	$HitFlashAnim.play("hit")
	hp -= damage
	if hp <= 0:
		die()

func die():
	pass
	#GameMan.register_npc_death(self)
	#%AnimSprite.hide()

#### ANIMATION / VISUALS ####################################

func play_anim_delayed(anim: String, delay: float):
	await get_tree().create_timer(delay).timeout
	%AnimSprite.play(anim)

func recalc_path():
	if target == null: return
	var tpos = Vector2i(GameMan.pos_to_cell(target))
	move_pts = grid.get_point_path(current_cell, tpos)
	move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
	$PathPreviz.points = move_pts
	target_cell = tpos

func play_move_anim(m: bool):
	if m:
		%AnimSprite.play("walk")
	else:
		%AnimSprite.play("default")

func set_facing_vis(dir: Vector2):
	if dir.y == 0.0:
		var should_face_right := facing_right
		if dir.x < 0:
			should_face_right = true
		else:
			should_face_right = false
		if should_face_right and not facing_right:
			%AnimSprite.set_flip_h(true)
			facing_right = true
		if not should_face_right and facing_right:
			%AnimSprite.set_flip_h(false)
			facing_right = false
	else:
		# didn't change h dir, do nothing
		pass
	

	
