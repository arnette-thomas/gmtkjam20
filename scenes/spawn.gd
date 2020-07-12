tool
extends Node2D

export (float) var radius = 10 setget _set_radius
export (int) var nb_spawn = 5
export (NodePath) var people_parent
export (String) var team = "brown"

func _set_radius(v):
	radius = v
	update()

var person = preload("res://scenes/person.tscn")

func _ready():
	var parent = get_node(people_parent)
	if not Engine.editor_hint:
		var rng = RandomNumberGenerator.new()
		for _i in range(nb_spawn):
			var p = person.instance()
			var angle = rng.randf_range(0, 2*PI)
			var dist = rng.randf_range(0, radius)
			p.position = dist * Vector2(cos(angle), sin(angle)) + position
			p.TEAM = team
			parent.add_child(p)


func _draw():
	if Engine.editor_hint:
		draw_circle(Vector2.ZERO, radius, Color(1, 1, 1, 0.5))
		draw_arc(Vector2.ZERO, radius, 0, 2*PI, 16, Color(0, 0, 0, 1), 5)
	
