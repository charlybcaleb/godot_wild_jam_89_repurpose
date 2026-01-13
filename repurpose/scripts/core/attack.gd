class_name Attack
extends RefCounted

var attacker: Node2D
var defender: Node2D
var dmg_die: int
var dmg_rolls: int
var speed: int
# set by this
var turn: int
var from: Vector2i
var to: Vector2i

func _init(_attacker: Node2D = null, _defender: Node2D = null, _die: int = 4, _rolls: int = 1, _spd: int = 100):
	attacker = _attacker
	defender = _defender
	dmg_die = _die
	dmg_rolls = _rolls
	speed = _spd
	turn = GameMan.get_turn()
	from = attacker.current_cell
	to = defender.current_cell
