extends TextureButton

var soul: Node2D
var enemy_data: EnemyData
var summon_pos: Vector2 # originally taken from domain itself.


func _on_pressed() -> void:
	print(get_parent().get_parent().click_pos)
	Domain.summon_at(GameMan.pos_to_cell(get_parent().get_parent().click_pos), GameMan.get_soul_from_enemy_data(enemy_data))
	get_parent().get_parent().hide_menu()
	pass # Replace with function body.
