extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var options = $VBoxContainer/VBoxOptions.get_children()
	for node in options:
		node.connect("mouse_entered", self, "on_option_mouseentered", [node])
		node.connect("mouse_exited", self, "on_option_mouseleaved", [node])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_option_mouseentered(emitter : Control):
	var label = emitter.get_child(1) as Label
	
func on_option_mouseleaved(emitter):
	print("LEAVE : ", emitter.get_children())
