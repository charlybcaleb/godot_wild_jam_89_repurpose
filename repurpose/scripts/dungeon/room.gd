extends Node2D

@export var room_data: RoomData
@export var spawn_points: Array[Node2D]
#@export var room_type:= RoomType.DUNGEON
@export var room_tml: TileMapLayer
@export var left_door: Node2D
@export var up_door: Node2D
@export var right_door: Node2D
@export var down_door: Node2D

#enum RoomType { DUNGEON, SOUL, }

# called by GameMan
func setup():
	spawn_enemies()
	if left_door: GameMan.register_door(left_door)
	if up_door: GameMan.register_door(up_door)
	if right_door: GameMan.register_door(right_door)
	if down_door: GameMan.register_door(down_door)

func spawn_enemies():
	var enemy_spawn_count = randi_range(room_data.min_enemies, room_data.max_enemies)
	for i in range(enemy_spawn_count):
		var enemy = room_data.get_enemy_weighted_random()
		if enemy:
			# tell gameman to spawn
			var spawn_pos = GameMan.pos_to_cell(get_unused_spawn_point().global_position)
			GameMan.spawn_npc(enemy, spawn_pos)
		else:
			# don't do anything, room has no enemies.
			pass

func get_unused_spawn_point() -> Node2D:
	if spawn_points.is_empty():
		return null
	var index = randi_range(0,spawn_points.size()-1)
	return spawn_points[index]
