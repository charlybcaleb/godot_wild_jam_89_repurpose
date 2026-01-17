class_name Effect
extends RefCounted


var name = "no_name"
var entity: Node2D #entity that is linked to this effect, if any.
var order = -1 #if -1, has no order set. order is set by placement in domain. (top left = first)
var remaining_charges= 0
# for persistent effects, we mark processed so we can stop adding its effect after added once,
# but still keep it in the stack so when it needs to be removed we can remove its effect
var processed = false 
var consumable = false # if true, removed from stack when charges_left = 0
var duration= 0 # in turns. if duration 0, lasts until removed from stack
var expires = false
var summon_charges= 0
var max_summon_charges= 0
var dmg_die_flat: int
var dmg_rolls_flat: int
var dmg_die_mlp: float
var hp_flat: int
var max_hp: int
# set by this

func _init(effect_data: EffectData = null, _entity: Node2D = null, _name = "omni", \
_remaining_charges= 0, _consumable = false, _duration = 0, _summon_charges = 0, \
_max_summon_charges = 0, _dmg_die_flat = 0, _dmg_rolls_flat = 0, _dmg_die_mlp = 0, \
_hp_flat = 0, _max_hp = 0 ):
	if effect_data:
		name = effect_data.name
		entity = _entity
		remaining_charges = effect_data.remaining_charges
		consumable = effect_data.consumable
		duration =effect_data.duration
		if duration > 0: expires = true
		summon_charges = effect_data.summon_charges
		max_summon_charges = effect_data.max_summon_charges
		dmg_die_flat = effect_data.dmg_die_flat
		dmg_rolls_flat = effect_data.dmg_rolls_flat
		dmg_die_mlp = effect_data.dmg_die_mlp
		hp_flat = effect_data.hp_flat
		max_hp = effect_data.max_hp
	else:
		name = _name
		entity = null
		remaining_charges = _remaining_charges
		consumable = _consumable
		duration = _duration
		summon_charges = _summon_charges
		max_summon_charges = _max_summon_charges
		dmg_die_flat = _dmg_die_flat
		dmg_die_mlp = _dmg_die_mlp
		hp_flat = _hp_flat
		max_hp = _max_hp
