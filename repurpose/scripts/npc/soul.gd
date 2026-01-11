extends Node2D

@export var soul_data: SoulData
var grid: AStarGrid2D
var current_cell: Vector2i

enum SoulState { IDLE, CHANNEL, WORK, HELD }
