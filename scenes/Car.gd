class_name Car

extends Node2D

var path_ref : Node2D

const PI_4 = PI / 4

func _process(_delta):
	var a = fmod(path_ref.global_rotation, 2*PI)
	var anim
	if a > -3*PI_4 and a <= -PI_4:
		anim = "up"
	elif a > -PI_4 and a <= PI_4:
		anim = "right"
	elif a > PI_4 and a <= 3*PI_4:
		anim = "down"
	else:
		anim = "left"
	$AnimatedSprite.play(anim)
