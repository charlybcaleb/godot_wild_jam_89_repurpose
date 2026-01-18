extends CharacterBody2D

#var loot_props: LootProperties
#var data: ItemData
@export var loot_name: String
@export var min_quantity = 25
@export var max_quantity = 50
var quantity: int
var domain = true

# called when spawned by gman
func setup():
	SoundMan.play_gem_drop()
	quantity = randi_range(min_quantity, max_quantity)
	$Label.text = str(quantity)
	send_gems_to_ui(quantity)

func set_quantity(new_quantity: int):
	quantity = new_quantity
	$Label.text = str(quantity)
	if quantity == 0:
		queue_free()

func send_gems_to_ui(amt: int):
	await get_tree().create_timer(0.2).timeout
	GameMan.player.heal(4)
	FxMan.spawn_and_send_gems_fx(global_position)
	hide()
	await get_tree().create_timer(0.5).timeout
	GameMan.add_gems(amt)
	set_quantity(0)
