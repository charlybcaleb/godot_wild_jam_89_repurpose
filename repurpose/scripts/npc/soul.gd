extends BaseMinion

@export var soul_data: SoulData
var soul_state:= SoulState.IDLE
@export var mouse_follow_speed:= 50.0

enum SoulState { IDLE, CHANNEL, WORK, HELD }

func _ready(): 
	GameMan.register_soul(self)
	add_to_group("soul")
	set_physics_process(false)

# called by Domain but should be called by GameMAn
func setup(_grid: AStarGrid2D, _data: EnemyData = null):
	super.setup(_grid, _data)

func _process(delta: float) -> void:
	if soul_state == SoulState.HELD:
		var mouse_pos = Vector2.ZERO
		mouse_pos = get_global_mouse_position()
		global_position = global_position.lerp(mouse_pos, delta * mouse_follow_speed)

func get_target() -> Node2D:
	var workables = get_tree().get_nodes_in_group("workable")
	# prune those not in domain 
	var to_prune = []
	for w in workables:
		if !GameMan.is_tile_in_domain(GameMan.pos_to_cell(w.global_position)):
			to_prune.append(w)
	for w in to_prune:
		workables.pop_at((workables.find(w)))
	
	var closest: Node2D
	var lowest_dist := 99.0
	if workables.size() > 0:
		for w in workables:
			var dist = GameMan.player.current_cell.distance_to(w.current_cell)
			if w.hp > 0 and dist < lowest_dist:
				lowest_dist = dist
				closest = w
		return closest
	else: return null

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton  \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed():
		if soul_state != SoulState.HELD:
			soul_state = SoulState.HELD
		else:
			#todo: check and see if over valid tile.
			soul_state = SoulState.IDLE
