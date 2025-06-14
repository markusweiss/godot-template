extends Camera2D

@export var shake_strength := 10
@export var shake_duration := 0.15

var _shake_timer := 0.0

func shake():
	_shake_timer = shake_duration

func _process(delta):
	if _shake_timer > 0:
		_shake_timer -= delta
		var offset = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		) * shake_strength

		if offset.length() > shake_strength:
			offset = offset.normalized() * shake_strength

		offset = offset.round()  # Für sauberen Pixellook
		position = offset
	else:
		position = Vector2.ZERO
