extends Node


var summon_fx_scene: PackedScene = preload("res://scenes/ui/summon_fx.tscn")
var summon_fx_instance: Node2D
var gem_fx_scene: PackedScene = preload("res://scenes/ui/gem_fx.tscn")
var gem_fx_instance: Node2D
var gem_display_node
var gem_send_speed = 0.4

func spawn_summon_fx(coord: Vector2i):
	summon_fx_instance = summon_fx_scene.instantiate()
	get_tree().current_scene.add_child(summon_fx_instance)
	var pos = GameMan.cell_to_pos(coord) + Vector2i((GlobalConstants.TILE_SIZE / 2.0),(GlobalConstants.TILE_SIZE / 2.0))
	summon_fx_instance.global_position = pos

func despawn_summon_fx():
	summon_fx_instance.queue_free()

func spawn_and_send_gems_fx(from_pos: Vector2, to_pos= Vector2.ZERO):
	if gem_fx_instance:
		gem_fx_instance.queue_free()
		
	gem_fx_instance = gem_fx_scene.instantiate()
	get_tree().current_scene.add_child(gem_fx_instance)
	gem_fx_instance.global_position = from_pos
	
	
	var final_pos

	if to_pos == Vector2.ZERO:
		gem_display_node = get_tree().get_first_node_in_group("gems_display")
		final_pos = gem_display_node.global_position
	else:
		final_pos = to_pos
	var tw = create_tween().set_parallel()
	#tw.finished.connect(_on_tween_finished)
	tw.tween_property(gem_fx_instance, "global_position", final_pos, gem_send_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw.tween_property(gem_fx_instance, "scale", Vector2(0.5, 0.5), gem_send_speed).set_trans(Tween.TRANS_LINEAR)
	#if gem_fx_instance.global_position.distance_to(final_pos) <= 25:
		#gem_fx_instance.queue_free()
	await get_tree().create_timer(0.45).timeout
	if gem_fx_instance: gem_fx_instance.queue_free()
		## FIXME: THIS IS CURSED BUT FUCK IT
