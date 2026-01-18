extends CharacterBody2D
class_name BaseMinion

## if true, targets player unless has no path to player, then targets nearest min
@export var assassin := false
@export var hp := 6
@export var max_hp := 6
@export var data: EnemyData
var entity_props: EntityProperties

var target: Node2D = null
var grid: AStarGrid2D
var current_cell: Vector2i
var cur_pt: int
var target_cell: Vector2i
var move_pts: Array

var facing_right: bool
var entity_type = GlobalConstants.EntityType.MINION
var ticks_alive= 0
var secs_alive = 0

signal health_changed(new_hp, _max_hp)

func _ready(): 
	GameMan.register_minion(self)
	add_to_group("minion")
	set_physics_process(false)

func _process(delta: float) -> void:
	secs_alive += delta

# called by GameMan
func setup(_grid: AStarGrid2D, _data: EnemyData = null):
	grid = _grid
	current_cell = GameMan.pos_to_cell(global_position)
	target_cell = current_cell
	if _data:
		data = _data
	hp = data.hp
	max_hp = data.hp
	
	var sprite_frames: SpriteFrames
	sprite_frames = load(data.get_necrofied_frames_path())
	if sprite_frames:
		$AnimSprite.sprite_frames = sprite_frames
	else: print("SETUP ERROR: sprite frames not found for " + name)

func set_entity_props(ep: EntityProperties):
	entity_props = ep
	emit_signal("health_changed", hp, entity_props.hp)

# FIXME: should go by path length, not global pos distance
# the minion version of this prioritizes enemies closest to player
func get_target() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest: Node2D
	var lowest_dist := 99.0
	if enemies.size() > 0:
		for e in enemies:
			var dist = GameMan.player.current_cell.distance_to(e.current_cell)
			if e.hp > 0 and dist < lowest_dist:
				lowest_dist = dist
				closest = e
		return closest
	else: return null

func set_target(t: Node2D):
		target = t

## called by GameMan when player moves
func tick(_delta: float) -> void:
	if hp <= 0: return
	ticks_alive+=1
	## MOVEMENT
	# FIXME: this is ratchet af, but maybe it will work to make enemies move after player and not overlap???
	await get_tree().create_timer(0.08).timeout
	if get_target() == null: return
	set_target(get_target())
	#if target == null or target.hp <= 0:
		#if get_target() == null: return
		#set_target(get_target())
		#if target: print("enemy targeted: " + target.name)
	if target != null:
		var tpos = Vector2i(GameMan.pos_to_cell(target.global_position))
		if tpos != tpos+Vector2i.UP: # FIXME: lol i turned this check off. cuz it was making enemies not move.!
			move_pts = grid.get_point_path(current_cell, tpos)
			var path_blocked = false
			for mp in move_pts:
				var mp_coord = (GameMan.pos_to_cell(mp))
				print("MINI PATH PT: " + str(mp_coord))
				# check if any points aside from start and end are blocked
				if move_pts.find(mp) != move_pts.size()-1 and \
				move_pts.find(mp) != 1 and \
				move_pts.find(mp) != 0:
					if GameMan.is_tile_blocked(mp_coord, false):
						path_blocked = true
						print("MINI PATH BLOCKED: " + str(mp_coord))
			# offset move_pts path by half the size of our tile size to get center
			# this must be done before movement. FIXME: this sucks
			move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
			# if path blocked, wander 1 tile instead and retry
			if path_blocked:
				var dir_to_target = Vector2(tpos - current_cell).normalized()
				#var one_tile_closer = current_cell + Vector2i(dir_to_target)
				var two_tiles_closer = current_cell + Vector2i(dir_to_target*2)
				move_pts = grid.get_point_path(current_cell, \
				GameMan.get_free_tile_near(GameMan.get_random_neighbor_tile(two_tiles_closer)))
				move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
			target_cell = tpos
			do_move()
			recalc_path()
	## ACTIONS
	if target != null:
		var att = Attack.new(self, target, entity_props.dmg_die, entity_props.dmg_rolls, entity_props.speed)
		GameMan.queue_attack(att)
		print("MINI QUEUED ATTACK!!!")
		return

func do_move():
	#print("move_pts size: " + str(move_pts.size()))
	if move_pts.is_empty(): return 
	cur_pt = 0;
	
	# check target range. if adjacent, do combat
	if target != null:
		var dist = GameMan.pos_to_cell(global_position).distance_to(
			GameMan.pos_to_cell(target.global_position))
		if dist < 1.8:
			print("arrived at dist " + str(dist))
			# probably flag for combat, then gman will do combat after TWEEN_DURATION delay
			#return
	
	if cur_pt == move_pts.size() -1:
		var move = Move.new(
			self, GameMan.pos_to_cell(global_position), GameMan.pos_to_cell(move_pts[-1]), entity_props.speed)
		GameMan.queue_move(move)
		# FIXME: do arrival logic
		#current_cell = GameMan.pos_to_cell(global_position)
		#tween_move(move_pts[-1])
		# viz
		$PathPreviz.points = []; 
		pass
	else:
		var move = Move.new(
			self, GameMan.pos_to_cell(global_position), GameMan.pos_to_cell(move_pts[cur_pt+1]), entity_props.speed)
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
	emit_signal("health_changed", hp-damage, max_hp)
	if hp <= 0:
		return
	hp -= damage
	$HitFlashAnim.play("hit")
	if hp <= 0:
		die()

func die(silent=false):
	GameMan.register_npc_death(self, silent)
	$Area2D.become_corpse(self, true)
	%AnimSprite.play("die")
	await %AnimSprite.animation_finished
	

#### ANIMATION / VISUALS ####################################

func recalc_path():
	if target == null: return
	var tpos = Vector2i(GameMan.pos_to_cell(target.position))
	move_pts = grid.get_point_path(current_cell, tpos)
	move_pts = (move_pts as Array).map(func(p): return p + grid.cell_size / 2.0)
	$PathPreviz.points = move_pts
	target_cell = tpos

func play_anim(anim: String, delay= 0.0):
	await get_tree().create_timer(delay).timeout
	%AnimSprite.play(anim)

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


func _on_area_2d_mouse_entered() -> void:
	pass # Replace with function body.
