extends Node2D

@export var fliege_scene : PackedScene = preload("res://features/Enemys/fly.tscn")
@export var min_spawn_time : float = 0.2
@export var max_spawn_time : float = 1.5

# Originalgrößen der Fliegen
var fliegen_original_scale = {}

# Puls-Simulation
@export var bpm : float = 120.0  # Beats pro Minute
var beat_timer : float = 0.0
var beat_period : float = 0.0  # Sekunden pro Beat

func _ready():
	randomize()

	# Spawn-Timer verbinden
	var timer = $Panel/SpawnFlyTimer
	if timer:
		timer.timeout.connect(Callable(self, "_spawn_fliege"))
		timer.start(randf_range(min_spawn_time, max_spawn_time))

	# Beat-Periode berechnen
	beat_period = 60.0 / bpm

	# Musik starten über AudioManager
	if AudioManager:
		AudioManager.stop_music()
		var beat_stream = preload("res://features/UI/main_menu/assets/sounds/beattest2.mp3")
		AudioManager.play_music(beat_stream)
		beat_stream.loop = true
		#AudioManager.set_spectrum_analyser(true)

func _process(delta):
	# Beat-Timer hochzählen
	beat_timer += delta

	# Puls-Simulation mit Sinuskurve (0..1)
	var pulse_strength = sin(beat_timer / beat_period * TAU) * 0.5 + 0.5

	_update_fliegen_scale(pulse_strength)

func _update_fliegen_scale(strength: float):
	for fliege in get_tree().get_nodes_in_group("fliegen"):
		if fliege not in fliegen_original_scale:
			fliegen_original_scale[fliege] = fliege.scale

		var original_scale = fliegen_original_scale[fliege]

		# Puls-Skala anwenden (max 50% größer)
		var scale_factor = 1.0 + strength * 0.9
		fliege.scale = fliege.scale.lerp(original_scale * scale_factor, 0.2)



func _spawn_fliege():
	var fliege = fliege_scene.instantiate()
	fliege.input_pickable = true
	add_child(fliege)
	var test = $Panel/FlyCount.text.to_int()
	
	# Testing around Sound Pitch
	if test > 1 and randf_range(1,10) > 6:
		$Panel/FlyCount.text = str(test - 1)
	if test >= 3 and test <= 5:
		AudioManager.set_pitch(1.1)
	elif test > 5:
		AudioManager.set_pitch(1.2)
	else:
		AudioManager.set_pitch(1.0)
		
	fliege.add_to_group("fliegen")
	$Panel/SpawnFlyTimer.start(randf_range(min_spawn_time, max_spawn_time))
