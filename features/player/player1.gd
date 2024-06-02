extends CharacterBody2D

# TODO: change const and make dynamic

const SPEED = 500.0
const STOP_LEFT = -500
const STOP_TOP = -270
const STOP_BOTTOM =240
var STOP_RIGHT = 500

# TODO: calc on dynamic screen size

func _ready():
	var viewport_size = get_viewport().size
	STOP_RIGHT = viewport_size.x - 650
	
	print(viewport_size)

func _physics_process(_delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED * _delta)
	
	move_and_slide()

	position.x = clamp(position.x, STOP_LEFT, STOP_RIGHT)
	position.y = clamp(position.y, STOP_TOP, STOP_BOTTOM)
