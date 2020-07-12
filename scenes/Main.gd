class_name Main

extends Node2D

var lvls = [
	preload("res://lvls/lvl1.tscn"),
	preload("res://lvls/lvl2.tscn"),
	preload("res://lvls/lvl3.tscn"),
	preload("res://lvls/lvl4.tscn"),
	preload("res://lvls/lvl5.tscn")
]
var curr_lvl = -1 # -1 is titlescreen

export (PackedScene) var titlescreen

var curr_scene_instance
var next_scene

func goto_scene(new_scene):
	next_scene = new_scene
	$Timer.start()

func next_level():
	if $Timer.time_left == 0:
		curr_lvl += 1
		if curr_lvl < lvls.size():
			goto_scene(lvls[curr_lvl])
		else:
			goto_titlescreen()

func restart_level():
	if curr_lvl < lvls.size():
		goto_scene(lvls[curr_lvl])
	else:
		goto_titlescreen()

func goto_titlescreen():
	if $Timer.time_left == 0:
		curr_lvl = -1
		goto_scene(titlescreen)

func _ready():
	goto_scene(titlescreen)
	$Timer.stop()

var prev_progress = -1

func _process(_delta):
	var progress = 2 * (0.5 - $Timer.time_left / $Timer.wait_time)
	$CanvasLayer/ColorRect.set_global_position(Vector2(480*progress, 0))
	if prev_progress < 0 and progress >= 0:
		if curr_scene_instance:
			curr_scene_instance.queue_free()
		curr_scene_instance = next_scene.instance()
		add_child(curr_scene_instance)
		if curr_lvl >= 0:
			$CanvasLayer/Pause.show()
			curr_scene_instance.connect("win", self, "next_level")
		else:
			$CanvasLayer/Pause.hide()
	prev_progress = progress
