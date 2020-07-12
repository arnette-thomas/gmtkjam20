extends Node2D

export (NodePath) var path_to_follow

export (float) var CAR_SPEED = 200
export (float) var CAR_PERIOD_SEC = 0.5
export (float) var CAR_PERIOD_INCERTITUDE = 0.3

var PATH

var car_scene = preload("res://scenes/Car.tscn")

var rng
# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	PATH = get_node(path_to_follow)
	$Timer.wait_time = CAR_PERIOD_SEC
	$Timer.start()

func _on_Timer_timeout():
	
	$Timer.wait_time = CAR_PERIOD_SEC + CAR_PERIOD_INCERTITUDE * rng.randf_range(-1, 1)
	$Timer.start()
	
	
	var pathfollow = PathFollow2D.new()
	PATH.add_child(pathfollow)
	
	var newcar = car_scene.instance()
	add_child(newcar)
	
	var node = Node2D.new()
	pathfollow.add_child(node)
	pathfollow.loop = false
	
	newcar.path_ref = pathfollow

func _physics_process(delta):
	print(get_children().size())
	for child in get_children():
		var car = child as Car
		if car:
			car.path_ref.offset += delta * CAR_SPEED
			car.global_position = car.path_ref.global_position
			if car.path_ref.unit_offset >= 1:
				car.path_ref.queue_free()
				car.queue_free()
