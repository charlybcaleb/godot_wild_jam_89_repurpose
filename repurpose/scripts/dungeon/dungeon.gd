extends Node2D

@export var map: TileMapLayer
var astar_grid: AStarGrid2D

func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.cell_size = map.tile_set.tile_size
	astar_grid.region = Rect2(Vector2.ZERO, ceil(get_viewport_rect().size / astar_grid.cell_size))
	astar_grid.update()
	build_grid()
	
	GameMan.RegisterDun(self)

func build_grid():
	for id in map.get_used_cells():
		var data = map.get_cell_tile_data(id)
		if data:
			if data.get_custom_data('obstacle'):
				astar_grid.set_point_solid(id, true)
			else:
				# if empty space
				astar_grid.set_point_solid(id, false)
	%UI/%GridDisplay.grid = astar_grid
	%Player.setup(astar_grid)

func get_path_from_to(from: Vector2, to: Vector2):
	
