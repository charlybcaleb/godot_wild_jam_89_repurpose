class_name EffectData
extends Resource


@export var name = "no_name"
@export var consumable = false # if true, removed from stack when
@export var remaining_charges= 0 # only used if consumable 
@export var duration= 0 # in turns. if duration 0, lasts until removed from stack
@export var summon_charges= 0
@export var max_summon_charges= 0
@export var dmg_die_flat: int
@export var dmg_rolls_flat: int
@export var dmg_die_mlp: float
@export var hp_flat: int
@export var max_hp: int
# set by this
