extends CenterContainer

const ads = [
	{
		texture = preload("res://Ads/AdAd.png"),
		url = "https://itch.io/jam/solodevelopment-game-jam"
	},
	{
		texture = preload("res://Ads/Bread.png"),
		url = "https://www.wikihow.com/Make-a-Quick-Homemade-Bread"
	},
	{
		texture = preload("res://Ads/GenderNode.png"),
		url = "https://docs.godotengine.org/en/stable/classes/class_node.html"
	}
]

var ad_idx = 0

signal ad_conversion(ad)

func _ready():
	next_ad()
	ads.shuffle()

func next_ad():
	ad_idx += 1
	ad_idx %= len(ads)
	visible = Settings.ads
	$Img.texture = ads[ad_idx].texture
	$AnimationPlayer.play("Ad")

func _on_Img_gui_input(event):
	var mbtn = event as InputEventMouseButton
	if mbtn:
		if mbtn.pressed and mbtn.button_index == BUTTON_LEFT:
			if ads[ad_idx].url != "":
				emit_signal("ad_conversion", ads[ad_idx])
				Settings.info(Settings.InfoCause.CLKAD)
				OS.shell_open(ads[ad_idx].url)
