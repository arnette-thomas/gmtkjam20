class_name Boid
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
	velocity *= mag
	velocity = velocity.rotated(angle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	v_repulsion = rule_repulsion()
	
	v_orientation = rule_orientation()
	v_attraction = rule_attraction()
	
	$Sprite.rotation = velocity.angle() + (PI / 2)
	$RayCast2D.rotation = velocity.angle() + (PI / 2)
	
func _physics_process(delta):
	# Raycasting to be afraid of walls
	if $RayCast2D.is_colliding():
		var collision_point = $RayCast2D.get_collision_point()
		var diff = collision_point - self.position
		if diff.length() <= $RepulsionArea/CollisionShape2D.shape.radius:
			velocity -= diff
	
	velocity += v_repulsion + v_orientation + v_attraction
	velocity = velocity.clamped(max_speed)
	move_and_slide(velocity)

### Rules ###

func rule_repulsion():
	var c = Vector2(0, 0)
	for node in nodes_repulsion:
		if node != self:
			c -= (node.position - self.position)
	c /= nodes_repulsion.size() - (1 if nodes_repulsion.size() > 1 else 0)
	return c
	
func rule_orientation():
	var c = Vector2(0, 0)
	for node in nodes_orientation:
		if node != self && !(node in nodes_repulsion):
			c += node.velocity
	c /= nodes_orientation.size() - (1 if nodes_orientation.size() > 1 else 0)
	return (c - self.velocity) / 8
	
func rule_attraction():
	var c = Vector2(0, 0)
	for node in nodes_attraction:
		if node != self && !(node in nodes_repulsion) && !(node in nodes_orientation):
			c += node.position
	c /= nodes_attraction.size() - (1 if nodes_attraction.size() > 1 else 0)
	return (c - self.position) / 100
	
### SLOTS ###

func _on_RepulsionArea_body_entered(body):
	if !nodes_repulsion.has(body) && 'Boid' in body.get_groups():
		nodes_repulsion.append(body)


func _on_RepulsionArea_body_exited(body):
	if nodes_repulsion.has(body):
		nodes_repulsion.remove(nodes_repulsion.find(body))


func _on_OrientationArea_body_entered(body):
	if !nodes_orientation.has(body) && 'Boid' in body.get_groups():
		nodes_orientation.append(body)


func _on_OrientationArea_body_exited(body):
	if nodes_orientation.has(body):
		nodes_orientation.remove(nodes_orientation.find(body))


func _on_AttractionArea_body_entered(body):
	if !nodes_attraction.has(body) && 'Boid' in body.get_groups():
		nodes_attraction.append(body)


func _on_AttractionArea_body_exited(body):
	if nodes_attraction.has(body):
		nodes_attraction.remove(nodes_attraction.find(body))
