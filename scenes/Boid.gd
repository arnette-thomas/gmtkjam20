extends KinematicBody2D

export var max_speed := 100

var velocity := Vector2(0, 1)

var nodes_repulsion := []
var v_repulsion := Vector2(0, 0)

var nodes_orientation := []
var v_orientation := Vector2(0, 0)

var nodes_attraction := []
var v_attraction := Vector2(0, 0)

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var mag = rng.randf_range(0, max_speed)
	var angle = rng.randf_range(0, 2 * PI)
	print(mag)
	print(angle)
	velocity *= mag
	velocity = velocity.rotated(angle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	v_repulsion = rule_repulsion()
	v_orientation = rule_orientation()
	v_attraction = rule_attraction()
	
func _physics_process(delta):
	velocity += v_repulsion + v_orientation + v_attraction
	velocity = velocity.clamped(max_speed)
	move_and_slide(velocity)

### Rules ###

func rule_repulsion():
	var c = Vector2(0, 0)
	for node in nodes_repulsion:
		if node != self:
			c -= (node.position - self.position)
	return c
	
func rule_orientation():
	var c = Vector2(0, 0)
	for node in nodes_orientation:
		c += node.velocity
	return (c - self.velocity) / 8
	
func rule_attraction():
	var c = Vector2(0, 0)
	for node in nodes_attraction:
		c += node.position
	c /= nodes_attraction.size()
	return (c - self.position) / 100
	
### SLOTS ###

func _on_RepulsionArea_body_entered(body):
	if !nodes_repulsion.has(body):
		nodes_repulsion.append(body)


func _on_RepulsionArea_body_exited(body):
	if nodes_repulsion.has(body):
		nodes_repulsion.remove(nodes_repulsion.find(body))


func _on_OrientationArea_body_entered(body):
	if !nodes_orientation.has(body):
		nodes_orientation.append(body)


func _on_OrientationArea_body_exited(body):
	if nodes_orientation.has(body):
		nodes_orientation.remove(nodes_orientation.find(body))


func _on_AttractionArea_body_entered(body):
	if !nodes_attraction.has(body):
		nodes_attraction.append(body)


func _on_AttractionArea_body_exited(body):
	if nodes_attraction.has(body):
		nodes_attraction.remove(nodes_attraction.find(body))
