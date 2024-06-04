extends CharacterBody2D

# TODO: Change to dynamic

const SPEED : int = 500
const STOP_LEFT : int = -500
const STOP_TOP : int = -270
const STOP_BOTTOM : int = 240
const STOP_RIGHT: int = 500

# 1 DRAG OFF < 1 is dragging
const DRAG : float = 1.0

var direction = Vector2.ZERO

# TODO: Change calc viewport

func _ready():
	var viewport_size = get_viewport().size
	#STOP_RIGHT = viewport_size.x - 650
	print(viewport_size)

func _physics_process(delta):
	var target_direction = Vector2.ZERO
	target_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	target_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	direction.x = lerp(direction.x, target_direction.x, DRAG)
	direction.y = lerp(direction.y, target_direction.y, DRAG)
	
	if direction != Vector2.ZERO:
		position += direction.normalized() * SPEED * delta
	
	position.x = clamp(position.x, STOP_LEFT, STOP_RIGHT)
	position.y = clamp(position.y, STOP_TOP, STOP_BOTTOM)
