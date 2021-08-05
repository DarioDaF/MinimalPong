extends Label

export var bloat: float = 1 setget _set_bloat

func update_center():
	var s = material as ShaderMaterial
	s.set_shader_param('center', rect_size / 2)

func _set_bloat(val):
	bloat = val
	var s = material as ShaderMaterial
	s.set_shader_param('bloat', bloat)
	update()

func _pleaze_kill_me():
	queue_free()

func _ready():
	update_center()
	$AnimationPlayer.play("Bloat")
