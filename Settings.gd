extends Node

signal added_money(amount)
signal new_ach(ach)

var ads = true
var show_one = true
var show_two = true
var show_ball = true
var good_ai = true
var shader = true

var money: int = 0

var hard_mul: int = 1
var soft_mul: int = 1

enum InfoCause {
	RELOAD,
	PONEWON,
	PTWOWON,
	OOT,
	OOB,
	MOVE,
	CLKAD,
	TIRED,
	RECOVERED,
	CHSETTINGS,
	MONEY,
	ACH
}

# Achievement:
#   First win (win for the first time)
#   First loss (lose for the first time)
#   Already tired? (loose while tired)
#   8h sleep (recover for the first time)
#   Easy loss (lose with bad ai)
#   Commercial (click on an ad)
#   Blind (complete a game with all show off)
#   Revenue killer (disable ads)
#   Paddle King (acquire 5000 $)
#   Minimalist (complete a game with all off)

class Achievement:
	const WIN = 'win'
	const LOSS = 'loss'
	const TIRED = 'tired'
	const SLEEP = 'sleep'
	const EASYLOSS = 'easyloss'
	const COMMERCIAL = 'commercial'
	const BLIND = 'blind'
	const PREMIUM = 'premium'
	const KING = 'king'
	const MINIMAL = 'minimal'
	const WHERE = 'where'
	const FULL = 'full'

const ach_locked = preload("res://Ach/Locked.png")

var achievements = {
	Achievement.WIN: {
		texture = preload("res://Ach/Win.png"),
		title = 'First Win',
		hint = 'Win for the first time',
		done = false
	},
	Achievement.LOSS: {
		texture = preload("res://Ach/Loss.png"),
		title = 'First Loss',
		hint = 'Lose for the first time',
		done = false
	},
	Achievement.TIRED: {
		texture = preload("res://Ach/Tired.png"),
		title = 'Already Tired?',
		hint = 'Lose while recovering',
		done = false
	},
	Achievement.SLEEP: {
		texture = preload("res://Ach/Sleep.png"),
		title = '8h Sleep',
		hint = 'Throw a slow ball',
		done = false
	},
	Achievement.EASYLOSS: {
		texture = preload("res://Ach/EasyLoss.png"),
		title = 'Disappointing',
		hint = 'Lose against bad AI',
		done = false
	},
	Achievement.COMMERCIAL: {
		texture = preload("res://Ach/Commercial.png"),
		title = 'Commercial',
		hint = 'Convert your visualizaion!',
		done = false
	},
	Achievement.BLIND: {
		texture = preload("res://Ach/Blind.png"),
		title = 'Blind',
		hint = 'Win without graphics',
		done = false
	},
	Achievement.PREMIUM: {
		texture = preload("res://Ach/Premium.png"),
		title = 'Revenue Killer',
		hint = 'Buy PREMIUM and disable ads',
		done = false
	},
	Achievement.KING: {
		texture = preload("res://Ach/King.png"),
		title = 'Paddle King',
		hint = 'Reach 5000 $',
		done = false
	},
	Achievement.MINIMAL: {
		texture = preload("res://Ach/Minimal.png"),
		title = 'Minimalist',
		hint = 'Win with all off',
		done = false
	},
	Achievement.WHERE: {
		texture = preload("res://Ach/Warp.png"),
		title = 'Warp Speed',
		hint = 'Escape the bounds of this realm',
		done = false
	},
	Achievement.FULL: {
		texture = preload("res://Ach/Full.png"),
		title = 'Complete Minimalist?',
		hint = 'Complete the game',
		done = false
	}
}

func set_ach(ach):
	if not achievements[ach]['done']:
		achievements[ach]['done'] = true
		emit_signal("new_ach", ach)
		info(InfoCause.ACH)

var recovering = false
var valid_full_play = true

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func info(cause):
	match cause:
		InfoCause.ACH:
			var all = true
			for i in achievements:
				if i == Achievement.FULL:
					continue
				if not achievements[i]['done']:
					all = false
					break
			if all:
				set_ach(Achievement.FULL)
		InfoCause.CLKAD:
			set_ach(Achievement.COMMERCIAL)
		InfoCause.PONEWON:
			set_ach(Achievement.WIN)
			if valid_full_play:
				if not show_one and not show_two and not show_ball:
					set_ach(Achievement.BLIND)
					if not good_ai and not shader and not ads:
						set_ach(Achievement.MINIMAL)
			valid_full_play = true
		InfoCause.PTWOWON:
			set_ach(Achievement.LOSS)
			if recovering:
				set_ach(Achievement.TIRED)
			if valid_full_play and not good_ai:
				set_ach(Achievement.EASYLOSS)
			valid_full_play = true
		InfoCause.OOT:
			set_ach(Achievement.SLEEP)
			valid_full_play = true
		InfoCause.OOB:
			set_ach(Achievement.WHERE)
			valid_full_play = true
		InfoCause.TIRED:
			recovering = true
		InfoCause.RECOVERED:
			recovering = false
		InfoCause.CHSETTINGS:
			valid_full_play = false
			if not ads:
				set_ach(Achievement.PREMIUM)
		InfoCause.MONEY:
			if money >= 5000:
				set_ach(Achievement.KING)

func update_settings():
	# Recompute muls
	hard_mul = 1
	soft_mul = 1
	if not show_one:
		hard_mul *= 8
		soft_mul *= 6
	if not show_ball:
		hard_mul *= 6
		soft_mul *= 4
	if not show_two:
		hard_mul *= 2
		soft_mul *= 2
	if not ads:
		hard_mul *= 2
		soft_mul *= 4
	for node in get_tree().get_nodes_in_group("settings_listeners"):
		node.update_settings()
	info(InfoCause.CHSETTINGS)

func add_money(amount):
	money += amount
	emit_signal("added_money", amount)
	info(InfoCause.MONEY)
