extends BaseMinion

@export var workable_when_charged = false
@export var currently_workable = false
@export var destroy_on_worked = false
@export var charges_gained_per_turn = 1
@export var max_charges = 5
@export var charged_effect: EffectData
@export var worked_effect: EffectData
var charges: int
var domain = false

signal charges_changed(new_charges, _max_charges)

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	GameMan.register_workable(self)
	add_to_group("workable")
	set_physics_process(false)

func tick(_delta: float):
	add_charges(charges_gained_per_turn)
	if charges == max_charges and charged_effect != null:
		var effect = Effect.new(charged_effect, self)
		GameMan.add_effect(effect)
	if charges == max_charges:
		currently_workable = true
		%AnimSprite.play("default")

func get_target() -> Node2D:
	return

func setup(_grid: AStarGrid2D, _data: EnemyData = null):
	super.setup(_grid, _data)
	entity_type = GlobalConstants.EntityType.WORKABLE
	%AnimSprite.play("die")

func effect_processed():
	pass

func revive():
	# so, we have to call this for non_workable workables.
	# that's because we manage their die() differently.
	# when a persistent workable dies, it isn't destroyed
	# it then revives itself when it gains its first charge back
	# actually fuck that!!!!! for now
	GameMan.register_workable(self)

func die(silent=true):
	# when worked this is called.
	if worked_effect:
		GameMan.add_effect(Effect.new(worked_effect, self))
	var loot_data = load(data.loot_data_path)
	if loot_data.min_loot > 0:
		GameMan.spawn_loot(data, GameMan.pos_to_cell(global_position))
	%AnimSprite.play("die")
	#await %AnimSprite.animation_finished
	if destroy_on_worked:
		GameMan.register_npc_death(self,silent)

func add_charges(amt: int):
	#if hp <= 0: # the idea is that when this is caleld, if the worker
		#revive()
	charges += amt
	if charges > max_charges: charges = max_charges
	#emit_signal("charges_changed", charges, max_hp)
	emit_signal("health_changed", charges, max_charges)
	$HitFlashAnim.play("hit")

#func take_damage(damage: float):
	#if !currently_workable:
		#emit_signal("health_changed", charges-damage, max_charges)
		#$HitFlashAnim.play("hit")
	#else:
		#super.take_damage(damage)

func remove_charges(amt: int):
	charges -= amt
	if charges < 0: charges = 0
	emit_signal("charges_changed", charges, max_hp)
