extends CharacterBody2D

## if true, targets player unless has no path to player, then targets nearest min
@export var assassin := false
var target: Node2D = null

var grid: AStarGrid2D
var current_cell: Vector2i
var cur_pt: int
var target_cell: Vector2i
var move_pts: Array

var facing_right: bool

func _ready(): 
	GameMan.register_enemy(self)
	add_to_group("enemies")
	set_physics_process(false)

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
	if minions.size() > 0:
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
		print("enemy targeted: " + target.name)
	if target != null:
		var tpos = Vector2i(GameMan.pos_to_cell(target.global_position))
		if tpos != target_cell:
			move_pts = grid.get_point_path(current_cell, tpos)
			# offset move_pts path by half the size of our tile size to get center
			move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
			$PathPreviz.points = move_pts
			target_cell = tpos
			do_move()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("debug")):
		do_move()

#func _process(_delta: float) -> void:
	#move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
	#$PathPreviz.points = move_pts

#func _input(event: InputEvent):
	#if event is InputEventMouseMotion:
		#var tpos = Vector2i(GameMan.pos_to_cell(event.position))
		#if tpos != target_cell:
			#move_pts = grid.get_point_path(current_cell, tpos)
			#move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
			#$PathPreviz.points = move_pts
			#target_cell = tpos


func do_move():
	print("move_pts size: " + str(move_pts.size()))
	if move_pts.is_empty(): return 
	cur_pt = 0;
	
	if cur_pt == move_pts.size() -1:
		# FIXME: do arrival logic
		current_cell = GameMan.pos_to_cell(global_position)
		global_position = move_pts[-1]
		# viz
		$PathPreviz.points = []; 
		play_move_anim(false)
		pass
	else:
		global_position = move_pts[cur_pt+1]
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
	

	
