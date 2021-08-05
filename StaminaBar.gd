extends Node2D

var stamina: float = 1
var recovering = false

func _process(delta):
	if not recovering and Input.is_action_pressed("game_sprint"):
		stamina -= delta
		if stamina < 0:
			stamina = 0
			recovering = true
			Settings.info(Settings.InfoCause.TIRED)
	stamina += 0.1*delta
	if stamina >= 1:
		stamina = 1
		recovering = false
		Settings.info(Settings.InfoCause.RECOVERED)
	update()

func _draw():
	draw_rect(Rect2(-5, -20, 10, 40), Color.black, true)
	draw_rect(Rect2(-5, -20+40*(1-stamina), 10, 40*stamina), Color.red if recovering else Color.white, true)
