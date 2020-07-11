extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity := Vector2(0, 0)
var nodes_repulsion := []
var v_repulsion := Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	v_repulsion = rule_repulsion()
	
func _physics_process(delta):
	velocity += v_repulsion
	move_and_slide(velocity)



func _on_RepulsionArea_body_entered(body):
	if !nodes_repulsion.has(body):
		nodes_repulsion.append(body)


func _on_RepulsionArea_body_exited(body):
	if nodes_repulsion.has(body):
		nodes_repulsion.remove(nodes_repulsion.find(body))

func rule_repulsion():
	var c = Vector2()
	for boid in nodes_repulsion:
		if boid != self:
			c -= (boid.position - self.position)
	return c
