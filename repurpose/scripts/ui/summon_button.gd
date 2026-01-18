extends TextureButton

var enemy_data: EnemyData
var summon_pos: Vector2 # originally taken from domain itself.


func _on_pressed() -> void:
	Domain.summon_at(GameMan.pos_to_cell(summon_pos), GameMan.get_soul_from_enemy_data(enemy_data))
	get_parent().get_parent().hide_menu()
	pass # Replace with function body.
