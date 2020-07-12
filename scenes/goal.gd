tool

extends Area2D

export (int) var nb_needed = 50
export (Font) var font
export (StyleBox) var style_box
export (Vector2) var size = Vector2(48, 48)
export (String) var team = "yellow"

var text = String(nb_needed)
var offset
var color = Color(1,1,1)

var is_full = false

func set_nb_shown(nb):
	text = String(nb)
	offset = -font.get_string_size(text) / 2
	offset.y += font.get_ascent()
	update()

func _ready():
	set_nb_shown(nb_needed)
	$CollisionShape2D.shape.extents = size / 2
	color = Teams.colors[team]
	color.a = 0.3
	
func _draw():
	style_box.bg_color = color
	draw_style_box(style_box, Rect2(-size/2, size))
	draw_string(font, offset , text, Color(0.3, 0.3, 0.3, 0.8) )
	

func _process(_delta):
	update()

func _physics_process(_delta):
	var nb_people = 0
	for body in get_overlapping_bodies():
		var person = body as Person
		if person:
			if person.TEAM == team:
				nb_people += 1
				
	is_full = nb_people >= nb_needed
	if is_full:
		set_nb_shown(0)
	else:
		set_nb_shown(nb_needed - nb_people)
