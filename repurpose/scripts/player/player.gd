extends CharacterBody2D

@export var hp:= 9

var grid: AStarGrid2D
var current_cell: Vector2i
var cur_pt: int
var target_cell: Vector2i
var move_pts: Array

var target: Vector2 = Vector2.ZERO

var facing_right: bool

func setup(_grid: AStarGrid2D):
	grid = _grid
	current_cell = GameMan.pos_to_cell(global_position)
	target_cell = current_cell

func _input(_event: InputEvent):
	var target_pos = current_cell
	if Input.is_action_just_pressed("move_left"):
		target_pos.x = current_cell.x - 1
		try_move(target_pos)
	if Input.is_action_just_pressed("move_right"):
		target_pos.x = current_cell.x + 1
		try_move(target_pos)
	if Input.is_action_just_pressed("move_up"):
		target_pos.y = current_cell.y - 1
		try_move(target_pos)
	if Input.is_action_just_pressed("move_down"):
		target_pos.y = current_cell.y + 1
		try_move(target_pos)

##
func try_move(target_pos: Vector2i):
	#target = target_pos
	#if target_pos != target_cell:
		#move_pts = grid.get_point_path(current_cell, target_pos)
		## offset move_pts path by half the size of our tile size to get center
		#move_pts = (move_pts as Array).map(
			#func (p): return p + grid.cell_size / 2.0)
		#$PathPreviz.points = move_pts
		#target_cell = target_pos
		#print("try move from " + str(current_cell) + "to " + str(target_cell))
		#process_move()
	target = target_pos
	print("move target: " + str(target))
	move_tick()

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
	print("move_pts size: " + str(move_pts.size()))
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
		play_move_anim(false)
		pass
	else:
		#global_position = move_pts[cur_pt+1]
		tween_move(move_pts[cur_pt+1])
		current_cell = GameMan.pos_to_cell(move_pts[cur_pt+1])
		cur_pt += 1
		# viz
		play_move_anim(true)


func tween_move(to: Vector2):
	var dur = GlobalConstants.MOVE_TWEEN_DURATION
	var tween = create_tween()
	tween.tween_property(self, "global_position", to, dur) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

#### ANIMATION / VISUALS ####################################

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
	

	
