extends CollisionShape2D

export var color: Color = Color.white
export var do_draw: bool = true

func _draw():
	if not do_draw:
		return
	var sh
	sh = shape as RectangleShape2D
	if sh:
		var v = Vector2(sh.extents.x, sh.extents.y)
		draw_colored_polygon([
			v * Vector2(+1, +1),
			v * Vector2(+1, -1),
			v * Vector2(-1, -1),
			v * Vector2(-1, +1)
		], color)
		return
	sh = shape as CircleShape2D
	if sh:
		draw_circle(Vector2(0, 0), sh.radius, color)
