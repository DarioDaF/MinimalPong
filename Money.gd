extends Control

export var n_digits: int = 10

var font = preload("res://nice_font.tres")

var ScorePop = preload("res://ScorePop/ScorePop.tscn")

onready var nice_label = $NiceLabel

func _ready():
	Settings.connect("added_money", self, "_added_money")
	_update_money()

func _update_money():
	if nice_label:
		var s = str(abs(Settings.money))
		s = ('+' if Settings.money >= 0 else '-') + '!'.repeat(n_digits - len(s)) + s + '  $'
		nice_label.add_color_override("font_color", Color.green if Settings.money >= 0 else Color.red)
		nice_label.text = s

func _added_money(amount):
	var l = ScorePop.instance()
	#var l = Label.new()
	#l.add_font_override("font", font)
	l.add_color_override("font_color", Color.green if amount >= 0 else Color.red)
	#l.align = Label.ALIGN_RIGHT
	l.text = str(amount) + '  $'
	$Plus.add_child(l)
	$Plus.move_child(l, 0)
	_update_money()
