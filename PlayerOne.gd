extends KinematicBody2D

export var speed: float = 80
export var speed_sprint: float = 180

func _ready():
	update_settings()

func update_settings():
	$Collision.visible = Settings.show_one
	$StaminaBar.visible = Settings.show_one

func _physics_process(delta):
	var s = speed_sprint if not $StaminaBar.recovering and Input.is_action_pressed("game_sprint") else speed
	$TopParticles.emitting = Input.is_action_pressed("game_down")
	$BottomParticles.emitting = Input.is_action_pressed("game_up")
	var v = 0
	if Input.is_action_pressed("game_down"):
		v += s
	if Input.is_action_pressed("game_up"):
		v -= s
	move_and_collide(Vector2(0, v*delta))
