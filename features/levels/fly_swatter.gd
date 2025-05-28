extends Sprite2D

@export var boundary_rect: Rect2 = Rect2(0, 0, 1024, 600)

var is_swinging := false
var swing_timer := 0.0
var swing_duration := 0.3
var start_pos: Vector2
var start_scale := Vector2.ONE
var max_scale := Vector2(1.5, 1.5)
var pull_back_offset := Vector2(0, -30)
var slam_offset := Vector2(0, 60)

func _ready():
	$Area2D/CollisionShape2D.disabled = true
	start_scale = scale

func _process(delta):
	if is_swinging:
		swing_timer += delta
		var t = swing_timer / swing_duration

		if t < 0.3:
			# Ausholen
			var lerp_pos = start_pos.lerp(start_pos + pull_back_offset, t / 0.3)
			var lerp_scale = start_scale.lerp(start_scale * 0.9, t / 0.3)
			position = lerp_pos
			scale = lerp_scale
		elif t < 0.7:
			# Zuschlagen
			var slam_t = (t - 0.3) / 0.4
			var slam_pos = start_pos + pull_back_offset
			var lerp_pos = slam_pos.lerp(start_pos + slam_offset, slam_t)
			var lerp_scale = (start_scale * 0.9).lerp(max_scale, slam_t)
			position = lerp_pos
			scale = lerp_scale
			$Area2D/CollisionShape2D.disabled = false
		else:
			# Zurück zur Maus
			var return_t = (t - 0.7) / 0.3
			var lerp_pos = (start_pos + slam_offset).lerp(start_pos, return_t)
			var lerp_scale = max_scale.lerp(start_scale, return_t)
			position = lerp_pos
			scale = lerp_scale

			if t >= 1.0:
				is_swinging = false
				swing_timer = 0.0
				scale = start_scale
				$Area2D/CollisionShape2D.disabled = true
	else:
		position = get_global_mouse_position().clamp(boundary_rect.position, boundary_rect.end)
		start_pos = position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not is_swinging:
		play_swatter_sound()
		is_swinging = true
		swing_timer = 0.0

func play_swatter_sound():
	var sound_player := AudioStreamPlayer2D.new()
	sound_player.stream = load("res://features/player/assets/sounds/swatter.mp3")
	sound_player.bus = "SFX"
	sound_player.global_position = global_position  # Oder setze eine andere Position
	add_child(sound_player)
	sound_player.play()
