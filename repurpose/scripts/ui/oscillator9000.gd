extends PanelContainer

@export var speed = 5.0
@export var start_offset = Vector2(0, -20)
@export var end_offset = Vector2(0, 20)
@onready var target_pos = Vector2.ZERO
@onready var orig_pos = global_position

func _ready() -> void:
	target_pos = orig_pos + start_offset
	print(str(target_pos))

func _process(delta: float) -> void:
	if global_position != target_pos:
		global_position = global_position.lerp(target_pos, delta * speed)
	if global_position.is_equal_approx(orig_pos + start_offset):
		print("ARRIVED")
		target_pos = orig_pos + end_offset
	if global_position.is_equal_approx(orig_pos + end_offset):
		target_pos = orig_pos + start_offset
