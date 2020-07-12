extends MarginContainer

signal back

var curr_line = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var back_node = $VBoxContainer/HBoxContainer
	back_node.connect("mouse_entered", self, "on_back_mouseentered", [back_node])
	back_node.connect("mouse_exited", self, "on_back_mouseleaved", [back_node])
	back_node.connect("clicked", self, "on_back_clicked")
	
	for node in $VBoxContainer/Sections.get_children():
		node.connect("mouse_entered", self, "on_section_mouseentered", [node])


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
	
func on_section_mouseentered(node):
	var textarea = $VBoxContainer/RichTextLabel
	match node.name:
		"Dev":
			textarea.set_text("ARNETTE Thomas\nBAR Augustin\nVERNAY Julien")
		"Engine":
			textarea.set_text("""
This game uses Godot Engine, available under the following license:
Copyright (c) 2007-2020 Juan Linietsky, Ariel Manzur. Copyright (c) 2014-2020 Godot Engine contributors.
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
			""")
		"Graphics":
			textarea.set_text("""
World Graphics from Kenney Game Assets

Character Graphics by Charles Gabriel 
https://opengameart.org/content/16x18-rpg-characters-hair-clothing-pack
			""")
		"Music":
			textarea.set_text("""
Vivacity by Kevin MacLeod
Link: https://incompetech.filmmusic.io/song/4593-vivacity
License: http://creativecommons.org/licenses/by/4.0/
			""")
	
	if node.name == "Engine":
		textarea.get('custom_fonts/normal_font').set_size(12)
	else:
		textarea.get('custom_fonts/normal_font').set_size(18)
