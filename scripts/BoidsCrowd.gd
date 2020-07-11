extends Node2D

const boidScn = preload("res://scenes/Boid.tscn")
export var nb_boids = 10
onready var VIEWPORT_SIZE = get_tree().root.get_viewport().size
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	for i in range(nb_boids):
		var boid = boidScn.instance()
		boid.position.x = rng.randi_range(0, VIEWPORT_SIZE.x)
		boid.position.y = rng.randi_range(0, VIEWPORT_SIZE.y)
		add_child(boid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
