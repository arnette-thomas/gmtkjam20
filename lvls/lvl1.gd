extends Node2D

signal win

func _process(_delta):
	if $goal2.is_full:
		emit_signal("win")
