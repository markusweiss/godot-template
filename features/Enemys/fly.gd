extends Area2D

@onready var sprite = $AnimatedSprite2D

var speed := Vector2.ZERO
var screen_size : Vector2

# Für Richtungsänderung
var change_dir_timer := 0.0
var change_dir_interval := 1.5  # Startwert – wird nach jeder Änderung neu zufällig gesetzt
var max_speed := 500  # Maximale Geschwindigkeit
var min_speed := 150  # Minimale Geschwindigkeit

func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	setup_spawn()
	sprite.play("fliegen")

func setup_spawn():
	var start_side = randi() % 4
	var target_pos : Vector2
	
	match start_side:
		0:
			position = Vector2(screen_size.x + 50, randf_range(0, screen_size.y))
			target_pos = Vector2(-50, randf_range(0, screen_size.y))
		1:
			position = Vector2(-50, randf_range(0, screen_size.y))
			target_pos = Vector2(screen_size.x + 50, randf_range(0, screen_size.y))
		2:
			position = Vector2(randf_range(0, screen_size.x), -50)
			target_pos = Vector2(randf_range(0, screen_size.x), screen_size.y + 50)
		3:
			position = Vector2(randf_range(0, screen_size.x), screen_size.y + 50)
			target_pos = Vector2(randf_range(0, screen_size.x), -50)
	
	var base_speed = randf_range(min_speed, max_speed)
	var direction = (target_pos - position).normalized()
	speed = direction * base_speed

	# Sprite-Rotation
	rotation = direction.angle() + deg_to_rad(90)  # Passe an je nach Sprite-Ausrichtung
	
	scale = Vector2.ONE * randf_range(0.8, 1.2)
	change_dir_timer = randf_range(1.0, 3.0)

func _process(delta):
	position += speed * delta

	change_dir_timer -= delta
	if change_dir_timer <= 0:
		change_direction()
		change_dir_timer = randf_range(1.0, 2.5)

	if position.x < -150 or position.x > screen_size.x + 150 or position.y < -150 or position.y > screen_size.y + 150:
		queue_free()

func change_direction():
	var direction = speed.normalized()
	
	# 20% Wahrscheinlichkeit für kompletten U-Turn
	if randf() < 0.2:
		direction = -direction
	else:
		# Richtungsänderung
		var angle_change = randf_range(-PI / 3, PI / 3)
		direction = direction.rotated(angle_change)

	# Geschwindigkeit erhöhen, wenn die Richtung geändert wurde
	var new_speed = speed.length() * 1.3  # 30% schneller
	if new_speed > max_speed:
		new_speed = max_speed  # Geschwindigkeit darf nicht über max_speed gehen
	speed = direction * new_speed
	
	# Neue Sprite-Ausrichtung
	rotation = direction.angle() + deg_to_rad(90)  # ggf. anpassen
