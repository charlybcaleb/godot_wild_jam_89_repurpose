extends Node2D

@export var map: TileMapLayer
@export var soulmaps: Array[TileMapLayer]
var astar_grid: AStarGrid2D

func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	#astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	#astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.cell_size = map.tile_set.tile_size
	astar_grid.region = Rect2(Vector2.ZERO, ceil(get_viewport_rect().size / astar_grid.cell_size))
	astar_grid.update()
	build_grid()
	
	GameMan.register_dun(self)

func build_grid():
	for id in map.get_used_cells():
		var data = map.get_cell_tile_data(id)
		if data:
			if data.get_custom_data('obstacle'):
				astar_grid.set_point_solid(id, true)
			else:
				# if empty space
				astar_grid.set_point_solid(id, false)
	for sm in soulmaps:
		for id in sm.get_used_cells():
			var data = sm.get_cell_tile_data(id)
			if data:
				if data.get_custom_data('obstacle'):
					astar_grid.set_point_solid(id, true)
				else:
					astar_grid.set_point_solid(id, false)
	%UI/%GridDisplay.grid = astar_grid

# called by GameMan when moving to new room
func new_map(m: TileMapLayer):
	map.queue_free()
	map = m
	build_grid()
	pass

func is_cell_obstacle(coord: Vector2i) -> bool:
	return astar_grid.is_point_solid(coord)

#func get_path_from_to(from: Vector2, to: Vector2):
	#
