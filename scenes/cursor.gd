class_name Cursor

extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var coef = 1
var active = false

func _process(delta):
	self.position = get_global_mouse_position()
	var attract_mode = Input.is_action_pressed("attract")
	if attract_mode || Input.is_action_pressed("repulse"):
		coef = abs(coef) * (-1 if attract_mode else 1)
		active = true
	else:
		active = false
		
	if Input.is_action_just_released("scale_up"):
		coef += 1
	if Input.is_action_just_released("scale_down"):
		coef -= (1 if coef > 1 else 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if active:
		for body in get_overlapping_bodies():
			var person = body as Person
			if person:
				var diff = person.position - position
				person.add_effect(coef * diff.normalized())
