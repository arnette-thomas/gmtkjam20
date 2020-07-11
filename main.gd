extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var cursor = preload("res://cursor.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var node
func _input(event):
	var mouse_event = event as InputEventMouseButton
	if mouse_event:
		if mouse_event.pressed:
			node = cursor.instance()
			node.position = mouse_event.position
			if mouse_event.button_index == BUTTON_LEFT:
				node.coef = -1
			elif mouse_event.button_index == BUTTON_RIGHT:
				node.coef = 1
			
			add_child(node)
