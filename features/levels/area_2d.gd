extends Area2D

func _ready():
	# Verbinde das area_entered Signal
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if not $CollisionShape2D.disabled:
		print("Treffer mit Area: ", area.name)
		play_splash_sound()
		area.queue_free()

func play_splash_sound():
	var sound_player := AudioStreamPlayer2D.new()
	sound_player.stream = load("res://features/Enemys/assets/sounds/splash.mp3")
	sound_player.bus = "SFX"
	sound_player.global_position = global_position  # Oder setze eine andere Position
	
	var current = $"../../Panel/FlyCount".text.to_int()
	$"../../Panel/FlyCount".text = str(current + 1)
	
	add_child(sound_player)
	sound_player.play()
