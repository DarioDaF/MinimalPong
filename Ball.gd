extends RigidBody2D

export var max_speed = 350

signal count_move
signal out_of_bounds

var player_side = true
var should_reset = true

func _ready():
	$Particles.rotation = PI + linear_velocity.angle()
	update_settings()

func update_settings():
	$Collision.visible = Settings.show_ball

func _integrate_forces(state):
	if should_reset:
		player_side = false
		state.transform.origin = Vector2(512, 300)
		state.linear_velocity = Vector2(-100, 0)
		$Timeout.start()
		linear_velocity = state.linear_velocity
		update_particles()
		should_reset = false

func _on_Ball_body_entered(body):
	var kb = body as KinematicBody2D
	if kb:
		$Timeout.start()
		linear_velocity *= 1.3
		linear_velocity.y += rand_range(-.5, +.5)
		if linear_velocity.length() > max_speed:
			linear_velocity = linear_velocity.normalized() * max_speed
	update_particles()
	$Bounce.play()

func update_particles():
	$Particles.rotation = PI + linear_velocity.angle()

func _process(delta):
	if position.x < -10 || position.x > 1034 || position.y < -10 || position.y > 710:
		emit_signal("out_of_bounds")
	if player_side and position.x > 512+10:
		player_side = false
		emit_signal("count_move")
	elif not player_side and position.x < 512-10:
		player_side = true
