extends CharacterBody2D

## if true, targets player unless has no path to player, then targets nearest min
@export var assassin := false
@export var hp := 6
@export var data: EnemyData
var target: Node2D = null

var grid: AStarGrid2D
var current_cell: Vector2i
var cur_pt: int
var target_cell: Vector2i
var move_pts: Array

var facing_right: bool

func _ready(): 
	GameMan.register_enemy(self)
	add_to_group("enemy")
	set_physics_process(false)

# called by GameMan
func setup(_grid: AStarGrid2D):
	grid = _grid
	current_cell = GameMan.pos_to_cell(global_position)
	target_cell = current_cell
	hp = data.hp

# FIXME: should go by path length, not global pos distance
func get_target() -> Node2D:
	var minions = get_tree().get_nodes_in_group("minion")
	var player = %Player
	var closest: Node2D
	# FIXME: needs to be if assassin AND has path to player.
	if(assassin): return player
	
	for m in minions:
		var lowest_dist := 99.0
		var dist = global_position.distance_to(m.global_position)
		if m.hp > 0 and dist < lowest_dist:
			lowest_dist = dist
			closest = m
	if closest != null: return closest
	else:
		return player

func set_target(t: Node2D):
		target = t

## called by GameMan when player moves
func tick(_delta: float) -> void:
	if hp <= 0: return
	## MOVEMENT
	# FIXME: this is ratchet af, but maybe it will work to make enemies move after player and not overlap???
	await get_tree().create_timer(0.08).timeout
	if target == null or target.hp <= 0:
		if get_target() == null: return
		set_target(get_target())
		if target: print("enemy targeted: " + target.name)
	if target != null:
		var tpos = Vector2i(GameMan.pos_to_cell(target.global_position))
		if tpos != target_cell:
			move_pts = grid.get_point_path(current_cell, tpos)
			# offset move_pts path by half the size of our tile size to get center
			move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
			target_cell = tpos
			do_move()
			recalc_path()
	## ACTIONS
	if target != null:
		var att = Attack.new(self, target, data.dmgDie, data.dmgRolls, data.speed)
		GameMan.queue_attack(att)
		return


func do_move():
	#print("move_pts size: " + str(move_pts.size()))
	if move_pts.is_empty(): return 
	cur_pt = 0;
	
	# check target range. if adjacent, do nothing
	if target != null:
		var dist = GameMan.pos_to_cell(global_position).distance_to(
			GameMan.pos_to_cell(target.global_position))
		if dist < 1.8:
			print("arrived at dist " + str(dist))
			# probably flag for combat, then gman will do combat after TWEEN_DURATION delay
			#return
	
	if cur_pt == move_pts.size() -1:
		var move = Move.new(
			self, GameMan.pos_to_cell(global_position), GameMan.pos_to_cell(move_pts[-1]), data.speed)
		GameMan.queue_move(move)
		# FIXME: do arrival logic
		#current_cell = GameMan.pos_to_cell(global_position)
		#tween_move(move_pts[-1])
		# viz
		$PathPreviz.points = []; 
		play_move_anim(false)
		pass
	else:
		var move = Move.new(
			self, GameMan.pos_to_cell(global_position), GameMan.pos_to_cell(move_pts[cur_pt+1]), data.speed)
		GameMan.queue_move(move)
		#print(name + " queued move!")
		# can we move here?
		#if GameMan.is_tile_occupied(move_pts[cur_pt+1]) or \
		#GameMan.is_player_moving_to_tile(move_pts[cur_pt+1]):
			#print ("enemy can't move, tile occupied")
			#return
		#tween_move(move_pts[cur_pt+1])
		#current_cell = GameMan.pos_to_cell(move_pts[cur_pt+1])
		#cur_pt += 1


func take_damage(damage: float):
	hp -= damage
	$HitFlashAnim.play("hit")
	if hp <= 0:
		die()

func die():
	GameMan.register_npc_death(self)
	%AnimSprite.hide()


#### ANIMATION / VISUALS ####################################

func recalc_path():
	if target == null: return
	var tpos = Vector2i(GameMan.pos_to_cell(target.position))
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

#### DEPRECATED / SAVE FOR LATER

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("debug")):
		recalc_path()

# path draw
#func _input(event: InputEvent):
	#if event is InputEventMouseMotion:
		#var tpos = Vector2i(GameMan.pos_to_cell(event.position))
		#if tpos != target_cell:
			#move_pts = grid.get_point_path(current_cell, tpos)
			#move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
			#$PathPreviz.points = move_pts
			#target_cell = tpos
