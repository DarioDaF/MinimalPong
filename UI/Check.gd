extends Label

signal changed(val)
signal unlock()

export var name_text = '' setget _set_name_text
export var enabled = false setget _set_enabled
export var value = false setget _set_value

func _set_name_text(val):
	name_text = val
	_update_props()

func _set_enabled(val):
	enabled = val
	_update_props()

func _set_value(val):
	value = val
	_update_props()

func _update_props():
	var c = Color.gray if not enabled else (
		Color.green if value else Color.red
	)
	add_color_override("font_color", c)
	text = ('~' if value else 'x') + '  ' + name_text

func _ready():
	_update_props()

func _on_Check_gui_input(event):
	var mb = event as InputEventMouseButton
	if mb:
		if mb.pressed and mb.button_index == BUTTON_LEFT:
			if enabled:
				self.value = !value
				emit_signal("changed", value)
			else:
				emit_signal("unlock")
