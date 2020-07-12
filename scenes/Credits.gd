extends MarginContainer

signal back

# Called when the node enters the scene tree for the first time.
func _ready():
	var back_node = $VBoxContainer/HBoxContainer
	back_node.connect("mouse_entered", self, "on_back_mouseentered", [back_node])
	back_node.connect("mouse_exited", self, "on_back_mouseleaved", [back_node])
	back_node.connect("clicked", self, "on_back_clicked")


func on_back_mouseentered(emitter : Control):
	var label = emitter.get_child(0) as Label
	label.get('custom_fonts/font').set_size(label.get('custom_fonts/font').size * 1.2)
	label.set('custom_colors/font_color', Color(1, 1, 0.8, 1))
	
func on_back_mouseleaved(emitter : Control):
	var label = emitter.get_child(0) as Label
	label.get('custom_fonts/font').set_size(label.get('custom_fonts/font').size / 1.2)
	label.set('custom_colors/font_color', Color(1, 1, 1, 1))
	
func on_back_clicked():
	emit_signal("back")
