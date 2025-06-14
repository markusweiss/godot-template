extends Node2D

@export var fliege_scene : PackedScene = preload("res://features/Enemys/fly.tscn")
@export var min_spawn_time : float = 0.2
@export var max_spawn_time : float = 1.5

@onready var player = $AudioStreamPlayer2D

@onready var spectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("Music"), 0)
var bass_strength : float = 0.0

func _process(_delta):
	if spectrum:
		#var spectrum_data = spectrum.get_magnitude_for_frequency_range(10, 300, 1)
		
		var bass = spectrum.get_magnitude_for_frequency_range(20, 250, 1)[0]
		var mids = spectrum.get_magnitude_for_frequency_range(250, 4000, 1)[0]
		var highs = spectrum.get_magnitude_for_frequency_range(4000, 20000, 1)[0]
		
		#bass_strength = spectrum_data[0]
		_update_fliegen_scale(bass)

func _update_fliegen_scale(strength: float):
	for fliege in get_tree().get_nodes_in_group("fliegen"):
		var base_scale = Vector2(1, 1)
		var scale_factor = clamp(strength * 20.0, 1.0, 3.0) # Werte anpassen!
		#fliege.scale = base_scale * scale_factor
		fliege.scale = fliege.scale.lerp(base_scale * scale_factor, 0.1)  # Der Wert 0.1 kontrolliert die Geschwindigkeit der Skalierung

func _ready():
	# Pause zuslassen
	# process_mode = Node.PROCESS_MODE_PAUSABLE
	# Musik initialisieren
	player.stream = load("res://features/UI/main_menu/assets/sounds/beattest2.mp3")
	player.stream.loop = true
	player.bus = "Music"
	player.play()
	
	randomize()
	$Panel/SpawnFlyTimer.timeout.connect(_spawn_fliege)
	$Panel/SpawnFlyTimer.start(randf_range(min_spawn_time, max_spawn_time))

func _spawn_fliege():
	var fliege = fliege_scene.instantiate()
	fliege.input_pickable = true
	add_child(fliege)
	fliege.add_to_group("fliegen")  # Wichtig für die Skalierung
	$Panel/SpawnFlyTimer.start(randf_range(min_spawn_time, max_spawn_time))
