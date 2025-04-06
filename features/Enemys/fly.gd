extends Area2D

@onready var sprite = $AnimatedSprite2D

var speed := Vector2.ZERO
var screen_size : Vector2
#var is_clickable := true  # Kann deaktiviert werden, wenn nötig

func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	setup_spawn()
	sprite.play("fliegen")
		
	#mouse_entered.connect(_on_mouse_entered)
	#mouse_exited.connect(_on_mouse_exited)
	#input_event.connect(_on_input_event)

func setup_spawn():
	# Zufällige Startposition an einem der Bildschirmränder
	var start_side = randi() % 4
	var target_pos : Vector2
	
	match start_side:
		0:  # Rechts
			position = Vector2(screen_size.x + 50, randf_range(0, screen_size.y))
			target_pos = Vector2(-50, randf_range(0, screen_size.y))
		1:  # Links
			position = Vector2(-50, randf_range(0, screen_size.y))
			target_pos = Vector2(screen_size.x + 50, randf_range(0, screen_size.y))
		2:  # Oben
			position = Vector2(randf_range(0, screen_size.x), -50)
			target_pos = Vector2(randf_range(0, screen_size.x), screen_size.y + 50)
		3:  # Unten
			position = Vector2(randf_range(0, screen_size.x), screen_size.y + 50)
			target_pos = Vector2(randf_range(0, screen_size.x), -50)
	
	# Zufällige Geschwindigkeitsvariation
	var base_speed = randf_range(100, 500)
	# Richtungsvektor zur Zielposition berechnen
	var direction = (target_pos - position).normalized()
	speed = direction * base_speed
	
	# Zusätzliche Zufallswerte
	scale = Vector2.ONE * randf_range(0.8, 1.2)
	rotation = randf_range(-0.3, 0.4)

func _process(delta):
	position += speed * delta
	# Löschen wenn außerhalb mit Puffer
	if position.x < -150 or position.x > screen_size.x + 150 or position.y < -150 or position.y > screen_size.y + 150:
		queue_free()

#signal fly_clicked

#func _on_input_event(viewport, event, shape_idx):
	#if not is_clickable:
	#	return
		
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
	#	print("Fly clicked and destroyed!")
		# Optional: Effekt vor dem Löschen abspielen
		#sprite.play("explode")  # Angenommen Sie haben eine Animation namens "explode"
		#await sprite.animation_finished
	#	fly_clicked.emit()
	#	queue_free()

#func _on_mouse_entered():
	# Optional: Mouse-over Effekt
#	if is_clickable:
#		sprite.modulate = Color(1.2, 1.2, 1.2)  # Leicht aufhellen

#func _on_mouse_exited():
	# Farbe zurücksetzen
#	sprite.modulate = Color.WHITE

func delete_me():
	queue_free()
