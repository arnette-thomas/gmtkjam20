class_name AttracEffect

extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	pass # Replace with function body.

var coef = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	for body in get_overlapping_bodies():
		var person = body as Person
		if person:
			var diff = person.position - position
			person.add_effect(coef * diff.normalized())


func _on_Timer_timeout():
	queue_free()
