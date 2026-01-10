extends CharacterBody2D

## if true, targets player unless has no path to player, then targets nearest min
@export var assassin := false
var target: Node2D = null

var grid: AStarGrid2D
var current_cell: Vector2i
var cur_pt: int
var target_cell: Vector2i
var move_pts: Array

var moving: bool:
	set(v):
		moving = v; $PathPreviz.visible = not moving; set_physics_process(moving)
var facing_right: bool

func _ready(): 
	GameMan.register_enemy(self)
	moving = false
	add_to_group("enemies")

# called by GameMan
func setup(_grid: AStarGrid2D):
	grid = _grid
	current_cell = GameMan.pos_to_cell(global_position)
	target_cell = current_cell

# FIXME: should go by path length, not global pos distance
func get_target() -> Node2D:
	var minions = get_tree().get_nodes_in_group("minion")
	var player = %Player
	var closest: Node2D
	if(assassin): return player
	if minions.length > 0:
		for t in minions:
			var lowest_dist := 99.0
			var dist = global_position.distance_to(t.global_position)
			if dist < lowest_dist:
				lowest_dist = dist
				closest = t
		return closest
	else:
		return player

func set_target(t: Node2D):
		target = t

## called by GameMan when player moves
func tick(_delta: float) -> void:
	if target == null or target.hp <= 0:
		set_target(get_target())
	if target != null:
		var tpos = Vector2i(GameMan.pos_to_cell(target.global_position))
		if tpos != target_cell:
			move_pts = grid.get_point_path(current_cell, tpos)
			# offset move_pts path by half the size of our tile size to get center
			move_pts = (move_pts as Array).map(
				func (p): return p + grid.cell_size / 2.0)
			$PathPreviz.points = move_pts
			target_cell = tpos
			start_move()
##

func start_move():
	if move_pts.is_empty(): return
	cur_pt = 0; moving = true
	play_move_anim(true)

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
		print(str(dir))
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
	

	
