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
			draw_rect(Rect2(p*grid.cell_size, grid.cell_size), col)
			#print( "set rect at point " + str(x) + "," + str(y))


func _on_show_grid_toggled(toggled_on: bool) -> void:
	toggle_grid_display(toggled_on)
