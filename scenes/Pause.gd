extends MarginContainer

var arrow_texture = preload("res://assets/arrowRight.png")
var empty_texture = preload("res://assets/arrowEmpty.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var options = $VBoxContainer/PauseMenu/VBoxContainer.get_children()
	for node in options:
		node.connect("mouse_entered", self, "on_option_mouseentered", [node])
		node.connect("mouse_exited", self, "on_option_mouseleaved", [node])
		node.connect("clicked", self, "on_option_clicked", [node])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func toggle_pause():
	var pause_menu = $VBoxContainer/PauseMenu
	pause_menu.visible = !pause_menu.visible
	get_tree().paused = pause_menu.visible

func _on_Pause_btn_pressed():
	toggle_pause()
	
func on_option_clicked(node):
	if node.name == 'ResumeOption':
		toggle_pause()
	if node.name == 'MainMenuOption':
		get_tree().change_scene("res://scenes/MainMenu.tscn")
		toggle_pause()
	on_option_mouseleaved(node)
	node.reset()
	
func on_option_mouseentered(emitter : Control):
	var label = emitter.get_child(1) as Label
	label.get('custom_fonts/font').set_size(label.get('custom_fonts/font').size * 1.2)
	label.set('custom_colors/font_color', Color(1, 1, 0.8, 1))
	
	var arrow = emitter.get_child(0) as TextureRect
	arrow.set_texture(arrow_texture)
	
func on_option_mouseleaved(emitter):
	var label = emitter.get_child(1) as Label
	label.get('custom_fonts/font').set_size(label.get('custom_fonts/font').size / 1.2)
	label.set('custom_colors/font_color', Color(1, 1, 1, 1))
	
	var arrow = emitter.get_child(0) as TextureRect
	arrow.set_texture(empty_texture)
	
