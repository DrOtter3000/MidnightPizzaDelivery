extends Control


var crosshair_type := 0


func draw_shape(shape: int) -> void:
	crosshair_type = shape


func _draw() -> void:
	match crosshair_type:
		0:
			draw_circle(Vector2.ZERO, 4, Color.DIM_GRAY)
			draw_circle(Vector2.ZERO, 3, Color.WHITE)
		
		1:
			draw_circle(Vector2.ZERO, 4, Color.DIM_GRAY)
			draw_circle(Vector2.ZERO, 3, Color.WHITE)
			
			draw_line(Vector2(16, 0), Vector2(24, 0), Color.DIM_GRAY, 3)
			draw_line(Vector2(-16, 0), Vector2(-24, 0), Color.DIM_GRAY, 3)
			draw_line(Vector2(0, 16), Vector2(0, 24), Color.DIM_GRAY, 3)
			draw_line(Vector2(0, -16), Vector2(0, -24), Color.DIM_GRAY, 3)
			
			draw_line(Vector2(16, 0), Vector2(24, 0), Color.WHITE, 1)
			draw_line(Vector2(-16, 0), Vector2(-24, 0), Color.WHITE, 1)
			draw_line(Vector2(0, 16), Vector2(0, 24), Color.WHITE, 1)
			draw_line(Vector2(0, -16), Vector2(0, -24), Color.WHITE, 1)
		
		2:
			draw_line(Vector2(16, 0), Vector2(24, 0), Color.DIM_GRAY, 3)
			draw_line(Vector2(-16, 0), Vector2(-24, 0), Color.DIM_GRAY, 3)
			draw_line(Vector2(0, 16), Vector2(0, 24), Color.DIM_GRAY, 3)
			draw_line(Vector2(0, -16), Vector2(0, -24), Color.DIM_GRAY, 3)
			
			draw_line(Vector2(16, 0), Vector2(24, 0), Color.WHITE, 1)
			draw_line(Vector2(-16, 0), Vector2(-24, 0), Color.WHITE, 1)
			draw_line(Vector2(0, 16), Vector2(0, 24), Color.WHITE, 1)
			draw_line(Vector2(0, -16), Vector2(0, -24), Color.WHITE, 1)
		
		3:
			draw_line(Vector2(24, -16), Vector2(24, 16), Color.DIM_GRAY, 3)
			draw_line(Vector2(-24, -16), Vector2(-24, 16), Color.DIM_GRAY, 3)
			draw_line(Vector2(-16, 24), Vector2(16, 24), Color.DIM_GRAY, 3)
			draw_line(Vector2(-16, -24), Vector2(16, -24), Color.DIM_GRAY, 3)
			
			draw_line(Vector2(24, -16), Vector2(24, 16), Color.WHITE, 1)
			draw_line(Vector2(-24, -16), Vector2(-24, 16), Color.WHITE, 1)
			draw_line(Vector2(-16, 24), Vector2(16, 24), Color.WHITE, 1)
			draw_line(Vector2(-16, -24), Vector2(16, -24), Color.WHITE, 1)
