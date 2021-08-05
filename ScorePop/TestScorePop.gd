extends Control

var ScorePop = preload("res://ScorePop/ScorePop.tscn")

func _on_Timer_timeout():
	var sp = ScorePop.instance()
	$Cont.add_child(sp)
