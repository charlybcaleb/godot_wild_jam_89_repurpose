extends CharacterBody2D

@export var soul_data: SoulData
var soul_state:= SoulState.IDLE

@export var mouse_follow_speed:= 50.0
var grid: AStarGrid2D
var current_cell: Vector2i
var cur_pt: int
var target_cell: Vector2i
var move_pts: Array

enum SoulState { IDLE, CHANNEL, WORK, HELD }

func _ready(): 
	#GameMan.register_soul(self)
	add_to_group("soul")
	set_physics_process(false)

# called by GameMan
func setup(_grid: AStarGrid2D):
	grid = _grid
	current_cell = GameMan.pos_to_cell(global_position)
	target_cell = current_cell

func _process(delta: float) -> void:
	if soul_state == SoulState.HELD:
		var mouse_pos = Vector2.ZERO
		mouse_pos = get_global_mouse_position()
		global_position = global_position.lerp(mouse_pos, delta * mouse_follow_speed)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton  \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed():
		if soul_state != SoulState.HELD:
			soul_state = SoulState.HELD
		else:
			#todo: check and see if over valid tile.
			soul_state = SoulState.IDLE
