extends BaseMinion

@export var soul_data: SoulData
var soul_state:= SoulState.IDLE
@export var heal_amt:= 4
@export var heal_every:= 3
var turns_since_spawned:=0

enum SoulState { IDLE, CHANNEL, WORK, HELD }

func _ready(): 
	GameMan.register_minion(self)
	add_to_group("minion")
	set_physics_process(false)

# called by Domain but should be called by GameMAn
func setup(_grid: AStarGrid2D, _data: EnemyData = null):
	super.setup(_grid, _data)

## called by GameMan when player moves
func tick(_delta: float) -> void:
	if hp <= 0: return
	turns_since_spawned +=1
	## MOVEMENT
	# FIXME: this is ratchet af, but maybe it will work to make enemies move after player and not overlap???
	await get_tree().create_timer(0.08).timeout
	if get_target() == null: return
	set_target(get_target())
	## ACTIONS
	if target != null and turns_since_spawned % heal_every == 0:
		var att = Attack.new(self, target, -heal_amt, 1, 100)
		GameMan.queue_attack(att)
		print("HEALER QUEUED ATTACK!!!")
		return

func get_target() -> Node2D:
	var minions = get_tree().get_nodes_in_group("minion")
	
	var closest: Node2D
	var lowest_dist := 99.0
	if minions.size() > 0:
		for m in minions:
			var dist = GameMan.player.current_cell.distance_to(m.current_cell)
			if m.hp > 0 and dist < lowest_dist:
				lowest_dist = dist
				closest = m
		return closest
	else: return null


#func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#if event is InputEventMouseButton  \
	#and event.button_index == MOUSE_BUTTON_LEFT \
	#and event.is_pressed():
		#if soul_state != SoulState.HELD:
			#soul_state = SoulState.HELD
		#else:
			##todo: check and see if over valid tile.
			#soul_state = SoulState.IDLE

func die(silent=true):
	GameMan.register_npc_death(self, silent)
	%AnimSprite.play("die")
	await %AnimSprite.animation_finished
