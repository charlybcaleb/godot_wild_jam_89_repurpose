extends Node2D

@export var room_data: RoomData
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

func spawn_enemies():
	var enemy_spawn_count = randi_range(room_data.min_enemies, room_data.max_enemies)
	for i in range(enemy_spawn_count):
		var enemy = room_data.get_enemy_weighted_random()
		if enemy:
			# tell gameman to spawn
			pass
		else:
			pass
			# don't do anything, room has no enemies.
	pass
