extends PanelContainer

var shop = [
	{
		text = 'Shader',
		prop = 'shader',
		cost = 0,
		bought = true
	},
	{
		text = 'Enemy!!!!!!!50  $',
		prop = 'show_two',
		cost = 50,
		bought = false
	},
	{
		text = 'GoodAI!!!!!100  $',
		prop = 'good_ai',
		cost = 100,
		bought = false
	},
	{
		text = 'Ball!!!!!!!100  $',
		prop = 'show_ball',
		cost = 100,
		bought = false
	},
	{
		text = 'Player!!!!!500  $',
		prop = 'show_one',
		cost = 500,
		bought = false
	},
	{
		text = 'Ads!!!!!!!3000  $',
		prop = 'ads',
		cost = 3000,
		bought = false
	}
]

var Check = preload("res://UI/Check.tscn")
var Ach = preload("res://UI/Ach.tscn")

func _new_ach(ach):
	$Ach.play()

func _unlock(i, c):
	var cost = i['cost']
	if Settings.money >= cost:
		Settings.add_money(-cost)
		i['bought'] = true
		c.enabled = true
		$Buy.play()
	else:
		$Nope.play()

func _changed(val, i):
	Settings.set(i['prop'], val)
	Settings.update_settings()

func set_pause(val):
	visible = val
	get_tree().paused = val

func _input(event):
	if Input.is_action_just_pressed('ui_cancel'):
		set_pause(not visible)

func _ready():
	Settings.connect("new_ach", self, "_new_ach")
	for i in shop:
		var c = Check.instance()
		c.name_text = i['text']
		c.enabled = i['bought']
		c.value = Settings.get(i['prop'])
		c.connect("unlock", self, "_unlock", [ i, c ])
		c.connect("changed", self, "_changed", [ i ])
		$H/Box/Options.add_child(c)
	for i in Settings.achievements:
		var a = Ach.instance()
		a.ach = i
		$H/Ach.add_child(a)

func _on_Ads_ad_conversion(ad):
	set_pause(true)
