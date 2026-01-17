extends BaseMinion

var domain = false

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	GameMan.register_workable(self)
	add_to_group("workable")
	set_physics_process(false)

func tick(_delta: float):
	return

func get_target() -> Node2D:
	return

func setup(_grid: AStarGrid2D, _data: EnemyData = null):
	super.setup(_grid, _data)
	entity_type = GlobalConstants.EntityType.WORKABLE

func die(silent=true):
	GameMan.register_npc_death(self,silent)
	#$Area2D.become_corpse(self, true)
	%AnimSprite.play("die")
	#await %AnimSprite.animation_finished
	GameMan.spawn_loot(data, GameMan.pos_to_cell(global_position))
	queue_free()
