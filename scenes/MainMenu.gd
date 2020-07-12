extends Node

var arrow_texture = preload("res://assets/arrowRight.png")
var empty_texture = preload("res://assets/arrowEmpty.png")
var credits = preload("res://scenes/Credits.tscn").instance()
var main = preload("res://scenes/MainMenuUI.tscn").instance()

export (PackedScene) var first_lvl_scene

var base_size

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(main)
	var options = main.get_node("VBoxContainer/VBoxOptions").get_children()
	base_size = main.get_node("VBoxContainer/VBoxOptions/StartOption/StartLabel").get('custom_fonts/font').size
	for node in options:
		node.connect("mouse_entered", self, "on_option_mouseentered", [node])
		node.connect("mouse_exited", self, "on_option_mouseleaved", [node])
		node.connect("clicked", self, "on_option_clicked", [node])
	credits.connect("back", self, "on_back_to_main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_option_mouseentered(emitter : Control):
	var label = emitter.get_child(1) as Label
	label.get('custom_fonts/font').set_size(base_size * 1.2)
	label.set('custom_colors/font_color', Color(1, 1, 0.8, 1))
	
	var arrow = emitter.get_child(0) as TextureRect
	arrow.set_texture(arrow_texture)
	
func on_option_mouseleaved(emitter):
	var label = emitter.get_child(1) as Label
	label.get('custom_fonts/font').set_size(base_size)
	label.set('custom_colors/font_color', Color(1, 1, 1, 1))
	
	var arrow = emitter.get_child(0) as TextureRect
	arrow.set_texture(empty_texture)

func on_option_clicked(node):
	if node.name == 'StartOption':
		(get_parent() as Main).next_level()
	if node.name == 'CreditsOption':
		#get_tree().change_scene("res://scenes/credits.tscn")
		add_child(credits)
		remove_child(main)
	if node.name == 'ExitOption':
		get_tree().quit(0)

func on_back_to_main():
	add_child(main)
	remove_child(credits)
