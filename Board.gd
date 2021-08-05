extends Node2D

func _added_money(amt):
	if amt > 0:
		$Money.play()

func _ready():
	randomize()
	Settings.connect("added_money", self, "_added_money")
	$GUI/PauseMenu.set_pause(true)

func reset_ball():
	print('ball_fee')
	Settings.add_money(-1)
	$Ball.should_reset = true

func _on_PlayerOneDeath_body_entered(body):
	print('WON P2')
	Settings.add_money(-10)
	reset_ball()
	$Loss.play()
	Settings.info(Settings.InfoCause.PTWOWON)

func _on_PlayerTwoDeath_body_entered(body):
	print('WON P1')
	Settings.add_money(20*Settings.hard_mul)
	reset_ball()
	Settings.info(Settings.InfoCause.PONEWON)

func _on_Timeout_timeout():
	print('Out of Time')
	Settings.add_money(100*Settings.hard_mul)
	reset_ball()
	Settings.info(Settings.InfoCause.OOT)

func _on_Ball_out_of_bounds():
	print('Out of bounds')
	Settings.add_money(1000*Settings.hard_mul)
	reset_ball()
	Settings.info(Settings.InfoCause.OOB)

func _on_Ball_count_move():
	print('Movement count')
	Settings.add_money(5*Settings.soft_mul)
	Settings.info(Settings.InfoCause.MOVE)

func update_settings():
	$CRT/ColorRect.visible = Settings.shader
