class_name Person

extends KinematicBody2D

const PI_4 = PI/4
var SELF_PONDER = 5
var RAD_REPULS = 0.3
var RAD_COHES = 0.7
var EFFECT_PONDER = 15

export (int) var SPEED = 100

var angle = 0
var direction = Vector2.ZERO
var rng

var result_effects = Vector2.ZERO
var nb_effects = 0

func add_effect(dir):
	result_effects += dir
	nb_effects += 1
	pass

func set_angle(a):
	a = fmod(a, 2*PI)
	angle = a
	direction.x = cos(angle)
	direction.y = sin(angle)
	if a > -3*PI_4 and a <= -PI_4:
		$AnimatedSprite.play("up")
	elif a > -PI_4 and a <= PI_4:
		$AnimatedSprite.play("right")
	elif a > PI_4 and a <= 3*PI_4:
		$AnimatedSprite.play("down")
	else:
		$AnimatedSprite.play("left")

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	set_angle(rng.randf_range(0, 2*PI))



func _physics_process(_delta):
	var left = $left1.is_colliding() or $left2.is_colliding() or $left3.is_colliding()
	var right = $right1.is_colliding() or $right2.is_colliding() or $right3.is_colliding()
	var down = $down1.is_colliding() or $down2.is_colliding() or $down3.is_colliding()
	var up = $up1.is_colliding() or $up2.is_colliding() or $up3.is_colliding()
	
	
	var result_influence = SELF_PONDER * direction + EFFECT_PONDER * result_effects
	var nb_influences = SELF_PONDER + EFFECT_PONDER * nb_effects
	
	for body in $InfluenceArea.get_overlapping_bodies():
		var other = body as Person
		if other:
			var diff = body.position - position
			if direction.dot(other.direction) > 0:
				var dist = diff.length() / $InfluenceArea/CollisionShape2D.shape.radius
				nb_influences += 1
				if dist < RAD_REPULS:
					result_influence += -diff.normalized()
				elif dist < RAD_COHES:
					result_influence += other.direction
				else:
					result_influence += diff.normalized()
	
	direction = result_influence / nb_influences
	
	if direction.x > 0 and right:
		direction.x -= 0.5
		direction.y += rng.randf_range(-0.1, 0.1)
	if direction.x < 0 and left:
		direction.x += 0.5
		direction.y += rng.randf_range(-0.1, 0.1)
	if direction.y > 0 and down:
		direction.y -= 0.5
		direction.y += rng.randf_range(-0.1, 0.1)
	if direction.y < 0 and up:
		direction.y += 0.5
		direction.y += rng.randf_range(-0.1, 0.1)
	
	var vel = direction * SPEED

	vel = move_and_slide(vel)
	if vel.x == 0 and vel.y == 0:
		$AnimatedSprite.stop()
	else:
		set_angle(atan2(vel.y, vel.x))
		
	result_effects = Vector2.ZERO
	nb_effects = 0
