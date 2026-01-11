extends CharacterBody2D

@export var hp:= 9

var grid: AStarGrid2D
var current_cell: Vector2i
var cur_pt: int
var target_cell: Vector2i
var move_pts: Array

var moving: bool:
	set(v):
		moving = v; $PathPreviz.visible = not moving; set_physics_process(moving)
var facing_right: bool

func _ready(): moving = false
func setup(_grid: AStarGrid2D):
	grid = _grid
	current_cell = GameMan.pos_to_cell(global_position)
	target_cell = current_cell

func _input(_event: InputEvent):
	if moving: return
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
	if target_pos != target_cell:
		move_pts = grid.get_point_path(current_cell, target_pos)
		# offset move_pts path by half the size of our tile size to get center
		move_pts = (move_pts as Array).map(
			func (p): return p + grid.cell_size / 2.0)
		$PathPreviz.points = move_pts
		target_cell = target_pos
		print("try move from " + str(current_cell) + "to " + str(target_cell))
	start_move()

func start_move():
	if move_pts.is_empty(): return
	cur_pt = 0; moving = true
	play_move_anim(true)
	GameMan.player_moved()

func _physics_process(_delta: float):
	if cur_pt == move_pts.size() -1:
		velocity = Vector2.ZERO
		global_position = move_pts[-1]
		current_cell = GameMan.pos_to_cell(global_position)
		$PathPreviz.points = []; moving = false
		play_move_anim(false)
	else:
		var dir = (move_pts[cur_pt + 1] - move_pts[cur_pt]).normalized()
		velocity = dir * GlobalConstants.NAV_SPEED
		move_and_slide()
		set_facing_vis(dir)
		# length comparator is in px
		if (move_pts[cur_pt + 1] - global_position).length() < 4:
			current_cell = GameMan.pos_to_cell(global_position)
			cur_pt += 1

#### ANIMATION / VISUALS ####################################

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
	

	
