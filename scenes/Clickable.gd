extends HBoxContainer

signal clicked
var is_hovered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")


func _input(event):
	if event is InputEventMouseButton and is_hovered:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked")

func on_mouse_entered():
	is_hovered = true
	
func on_mouse_exited():
	is_hovered = false
