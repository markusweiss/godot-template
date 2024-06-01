extends CharacterBody2D

const SPEED = 500.0
const STOP_LEFT = -60
var STOP_RIGHT = 600


func _ready():
	var viewport_size = get_viewport().size
	STOP_RIGHT = viewport_size.x - STOP_LEFT - 240

func _physics_process(_delta):
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

	position.x = clamp(position.x, STOP_LEFT, STOP_RIGHT)
