class_name Cursor

extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

var coef = 1
var active = false

func _process(delta):
	position = get_viewport().get_mouse_position()
	var attract_mode = Input.is_action_pressed("attract")
	if attract_mode || Input.is_action_pressed("repulse"):
		coef = abs(coef) * (-1 if attract_mode else 1)
		active = true
	else:
		active = false
		
	if Input.is_action_just_released("scale_up"):
		$CollisionShape2D.shape.radius += 10
	if Input.is_action_just_released("scale_down"):
		var rad = $CollisionShape2D.shape.radius
		$CollisionShape2D.shape.radius -= (10 if rad > 10 else 0)
		
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if active:
		for body in get_overlapping_bodies():
			var person = body as Person
			if person:
				var diff = person.global_position - global_position
				person.add_effect(coef * diff.normalized())

func _draw():
	var progress = $Timer.time_left / $Timer.wait_time
	var radius = $CollisionShape2D.shape.radius
	
	var color = Color(0.5, 0.5, 0.5, 0.3)
	if active:
		if coef > 0:
			color = Color(1, 0.5, 0, 0.3)
			progress = 1 - progress
		else:
			color = Color(0, 0.5, 1, 0.3)
		draw_arc(Vector2.ZERO, progress*radius, 0, 2*PI, 30, Color(0,0,0,0.2), 15)
		
	draw_circle(Vector2.ZERO, radius, color)
	draw_arc(Vector2.ZERO, radius, 0, 2*PI, 30, Color(0,0,0,0.3), 3)
	
