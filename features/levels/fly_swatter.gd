extends Sprite2D

@export var boundary_rect: Rect2 = Rect2(0, 0, 1024, 600)

func _ready():
	# Starte mit DEAKTIVIERTER Kollision
	$Area2D/CollisionShape2D.disabled = true
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	# Mausposition verfolgen (innerhalb der Boundary)
	var mouse_pos = get_global_mouse_position()
	position = mouse_pos.clamp(boundary_rect.position, boundary_rect.end)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Kollision NUR AKTIVIEREN, solange die Maus gedrückt ist
			$Area2D/CollisionShape2D.disabled = not event.pressed
			print("Kollision:", " aktiviert" if event.pressed else " deaktiviert")
