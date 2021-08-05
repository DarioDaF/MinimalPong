extends KinematicBody2D

export var ball_path: NodePath

export var speed: float = 100
export var min_offset: int = 5

func _ready():
	update_settings()

func update_settings():
	$Collision.visible = Settings.show_two

# Returns -1, 0, +1
func bad_ai():
	var ball = get_node(ball_path) as Node2D
	var my_y = global_position.y
	var target_y = ball.global_position.y
	if abs(target_y - my_y) > min_offset:
		if target_y > my_y:
			return +1
		else:
			return -1
	return 0

func good_ai():
	var ball = get_node(ball_path) as RigidBody2D
	var my_pos = global_position
	var target_pos = ball.global_position
	var target_vel = ball.linear_velocity
	if abs(target_vel.x) < 1:
		# Low vel_x, shit approx, use bad AI!!!
		return bad_ai()
	var delta_y = (my_pos.x - target_pos.x) * target_vel.y / target_vel.x
	var target_y = target_pos.y + delta_y
	
	# If in your field stay in center
	if target_pos.x < 512:
		target_y = 300
	
	if abs(target_y - my_pos.y) > min_offset:
		if target_y > my_pos.y:
			return +1
		else:
			return -1
	return 0

func ai():
	return good_ai() if Settings.good_ai else bad_ai()

func _physics_process(delta):
	var mov = ai()
	$TopParticles.emitting = mov > 0
	$BottomParticles.emitting = mov < 0
	move_and_collide(Vector2(0, mov * speed * delta))
