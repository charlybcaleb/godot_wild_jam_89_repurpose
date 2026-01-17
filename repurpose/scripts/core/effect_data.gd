class_name EffectData
extends Resource


var name = "no_name"
var consumable = false # if true, removed from stack when
var remaining_charges= 0 # only used if consumable 
var duration= 0 # in turns. if duration 0, lasts until removed from stack
var summon_charges= 0
var max_summon_charges= 0
var dmg_die_flat: int
var dmg_rolls_flat: int
var dmg_die_mlp: float
var hp_flat: int
var max_hp: int
# set by this
