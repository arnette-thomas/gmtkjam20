
class_name Person

extends KinematicBody2D

const PI_4 = PI/4
var SELF_PONDER = 5
var RAD_REPULS = 0.3
var RAD_COHES = 0.75
var EFFECT_PONDER = 50

export (int) var SPEED = 80
export (String) var TEAM = "brown"
export (String) var anim = "down"

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
		anim = "up"
	elif a > -PI_4 and a <= PI_4:
		anim = "right"
	elif a > PI_4 and a <= 3*PI_4:
		anim = "down"
	else:
		anim = "left"


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	set_angle(rng.randf_range(0, 2*PI))
	$Sprite.texture = Teams.textures[TEAM]
	$Sprite.region_enabled = true
	$Timer.start()

const SPRITE_DIM = Vector2(16,18)

const lut_ry = {
	up = 0,
	left = 3,
	right = 1,
	down = 2
}

func get_rx(progress):
	print(progress)
	var rx
	if progress < 0.25:
		rx = 0
	elif progress < 0.5:
		rx = 1
	elif progress < 0.75:
		rx = 2
	else:
		rx = 1
	return rx * SPRITE_DIM.x

func _process(_delta):
	var rx = get_rx(1 - $Timer.time_left / $Timer.wait_time)
	var ry = lut_ry[anim] * SPRITE_DIM.y
	$Sprite.region_rect = Rect2(rx, ry, SPRITE_DIM.x, SPRITE_DIM.y)

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
		pass
	else:
		set_angle(atan2(vel.y, vel.x))
		
	result_effects = Vector2.ZERO
	nb_effects = 0
