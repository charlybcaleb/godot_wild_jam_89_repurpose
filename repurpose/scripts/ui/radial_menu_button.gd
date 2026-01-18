extends TextureButton
class_name RadialMenuButton

@export var pos_offset = Vector2(-16, -16)
@export var radius = 32
@export var speed = 0.25
@export var summon_button_scene: PackedScene

var num
var active = false
var click_pos

func _ready():
	GameMan.connect("souls_changed", Callable(self, "_on_souls_changed"))
	GameMan.connect("began_tick", Callable(self, "_on_began_tick"))
	Domain.connect("show_summon_menu", Callable(self, "_on_show_summon_menu"))
	
	$Buttons.hide()
	num = $Buttons.get_child_count()
	#connect("pressed", Callable(self, "_on_StartButton_pressed"))

func setup_buttons():
	num = $Buttons.get_child_count()

func _on_began_tick():
	if active:
		hide_menu()
	

func _on_show_summon_menu(pos: Vector2):
	click_pos = pos
	global_position = pos + pos_offset
	var buttons = $Buttons.get_children()
	for b in buttons:
		b.queue_free()
	for s in GameMan.souls:
		create_button(s.data, s)
	setup_buttons()
	show_menu()

func _on_souls_changed(_s: Node2D):
	pass

func create_button(data: EnemyData, soul: Node2D):
	var button = summon_button_scene.instantiate()
	$Buttons.add_child(button)
	var icon = load(data.get_icon_path())
	button.texture_normal = icon
	button.enemy_data = data
	button.soul = soul

func show_menu():
	print("showing")
	$Buttons.show()
	var spacing = TAU / num
	active = true
	var tw = create_tween().set_parallel()
	tw.finished.connect(_on_tween_finished)
	for b in $Buttons.get_children():
		var a = spacing * b.get_index() - PI / 2
		var dest = Vector2(radius, 0).rotated(a)
		tw.tween_property(b, "position", dest, speed).from(Vector2.ZERO).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_property(b, "scale", Vector2.ONE, speed).from(Vector2(0.5, 0.5)).set_trans(Tween.TRANS_LINEAR)
	Domain.menu_open = true

func hide_menu():
	print("hiding")
	active = false
	var tw = create_tween().set_parallel()
	tw.finished.connect(_on_tween_finished)
	for b in $Buttons.get_children():
		tw.tween_property(b, "position", Vector2.ZERO, 0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tw.tween_property(b, "scale", Vector2(0.5, 0.5), 0).set_trans(Tween.TRANS_LINEAR)
	Domain.menu_open = false


func _on_pressed():
	disabled = true
	if active:
		hide_menu()
	else:
		show_menu()


func _on_tween_finished():
	disabled = false
	if not active:
		$Buttons.hide()
