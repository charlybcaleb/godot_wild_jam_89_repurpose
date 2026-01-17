extends CharacterBody2D

#var loot_props: LootProperties
#var data: ItemData
@export var loot_name: String
@export var min_quantity = 5
@export var max_quantity = 50
var quantity: int
var domain = true

func setup():
	quantity = randi_range(min_quantity, max_quantity)
	$Label.text = str(quantity)

func set_quantity(new_quantity: int):
	quantity = new_quantity
	$Label.text = str(quantity)
	if quantity == 0:
		queue_free()
