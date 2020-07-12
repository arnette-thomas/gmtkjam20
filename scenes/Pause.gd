extends MarginContainer

var arrow_texture = preload("res://assets/arrowRight.png")
var empty_texture = preload("res://assets/arrowEmpty.png")

var music_off = preload("res://assets/musicOff.png")
var music_off_hover = preload("res://assets/musicOff_hover.png")
var music_off_press = preload("res://assets/musicOff_press.png")
var music_on = preload("res://assets/musicOn.png")
var music_on_hover = preload("res://assets/musicOn_hover.png")
var music_on_press = preload("res://assets/musicOn_press.png")
var muted = false

export (NodePath) var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	var options = $VBoxContainer/PauseMenu/VBoxContainer.get_children()
	for node in options:
		node.connect("mouse_entered", self, "on_option_mouseentered", [node])
		node.connect("mouse_exited", self, "on_option_mouseleaved", [node])
		node.connect("clicked", self, "on_option_clicked", [node])
	if (get_node(parent) as Main).get_node("AudioStreamPlayer").stream_paused != muted:
		toggle_mute()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func toggle_pause():
	var title = $VBoxContainer/HBoxContainer/Title
	title.visible = !title.visible
	
	var pause_menu = $VBoxContainer/PauseMenu
	pause_menu.visible = !pause_menu.visible
	get_tree().paused = pause_menu.visible
	
func toggle_mute():
	var btn = $VBoxContainer/HBoxContainer/Mute_btn
	if muted:
		btn.set_normal_texture(music_off)
		btn.set_hover_texture(music_off_hover)
		btn.set_pressed_texture(music_off_press)
	else:
		btn.set_normal_texture(music_on)
		btn.set_hover_texture(music_on_hover)
		btn.set_pressed_texture(music_on_press)
	muted = !muted
	
	(get_node(parent) as Main).get_node("AudioStreamPlayer").stream_paused = muted
	

func _on_Pause_btn_pressed():
	toggle_pause()
	
func on_option_clicked(node):
	if node.name == 'ResumeOption':
		toggle_pause()
	if node.name == 'RestartOption':
		(get_node(parent) as Main).restart_level()
		toggle_pause()
	if node.name == 'NextOption':
		(get_node(parent) as Main).next_level()
		toggle_pause()
	if node.name == 'MainMenuOption':
		#get_tree().change_scene("res://scenes/MainMenu.tscn")
		(get_node(parent) as Main).goto_titlescreen()
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
	


func _on_Mute_btn_pressed():
	toggle_mute()
