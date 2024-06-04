extends CharacterBody2D

signal player_died

@export var SPEED = 400.0
const JUMP_VELOCITY = -400.0
const MAX_JUMP_CHARGE = 2.0
var jump_charge = 0.0
var accel_y = 0.0
var is_dead = false
var is_paused = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if is_paused:
		move_and_slide()
		return;
		
	if is_on_floor():
		if not is_dead:
			on_death()
			is_dead = true
		
	# Add the gravity.
	accel_y += gravity * delta
	velocity.y += accel_y * delta
		
	if is_dead:
		velocity.x = 0.0
	else:
		$AnimatedSprite2D.speed_scale = -velocity.y * 0.004

		if Input.is_action_pressed("jump"):
			# Charging a jump
			jump_charge += delta
			jump_charge = clamp(jump_charge, 0, MAX_JUMP_CHARGE)
			$AnimatedSprite2D.play('charge')
		elif Input.is_action_just_released("jump"):
			# Releasing a jump
			velocity.y = JUMP_VELOCITY * (jump_charge + 1)
			accel_y = 0.0
			jump_charge = 0
			$AnimatedSprite2D.play('flap')
		elif velocity.y > 0.0 and $AnimatedSprite2D.animation == 'flap':
			$AnimatedSprite2D.play('glide')

		velocity.x = SPEED

	move_and_slide()

func on_death():
	player_died.emit()
	
func get_ready(startPosition):
	position = startPosition
	velocity.x = 0.0
	velocity.y = 0.0
	accel_y = 0.0
	$AnimatedSprite2D.play('glide')
	is_paused = true

func go():
	is_paused = false
	is_dead = false
