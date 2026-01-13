extends Control

var grid: AStarGrid2D:
	set(v): grid = v; queue_redraw()
var show_grid_display: bool:
	set(v): show_grid_display = v; queue_redraw()

func toggle_grid_display(on: bool):
	show_grid_display = on

func _draw():
	if not grid or not show_grid_display: 
		print("no grid")
		return
	for x in grid.region.size.x:
		for y in grid.region.size.y:
			var p = Vector2(x, y)
			var col = Color(1,0,0,0.5) if grid.is_point_solid(p) else Color(0,1,0,0.3)
			var world_p = p * grid.cell_size
			#var camOffset = GameMan.CamWorldPos()
			draw_rect(Rect2(world_p, grid.cell_size), col)
			#print( "set rect at point " + str(x) + "," + str(y))
			var occ_col = Color(0.0, 1.533, 2.858, 0.475)
			if GameMan.is_tile_occupied(p):
				draw_rect(Rect2(world_p, grid.cell_size), occ_col)


func _on_show_grid_toggled(toggled_on: bool) -> void:
	toggle_grid_display(toggled_on)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
		show_grid_display = true
		_draw()
		
		var free_tile = Vector2(GameMan.get_free_tile_near(Vector2i(19,19)))
		var col = Color(0.0, 0.988, 0.0, 0.49)
		var world_ft = free_tile * grid.cell_size
		if free_tile.x >= 900:
			print ("FREE TILE NOT FOUND"); return
		print ("FREE TILE FOUND AT: " + str(free_tile))
		draw_rect(Rect2(world_ft, grid.cell_size), col)
