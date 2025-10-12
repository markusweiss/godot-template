# AudioManager.gd
extends AudioStreamPlayer2D

# Aktuelle Musik
var current_stream: AudioStream = null
var original_volume_db: float


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	if AudioManager:
		self.connect("pause_toggled", Callable(AudioManager, "_on_pause_toggled"))

func play_music(stream: AudioStream):
	if current_stream == stream and playing:
		return # schon die richtige Musik, nichts tun
	current_stream = stream
	self.stream = stream
	play()

func stop_music():
	stop()
	
func set_pitch(pitch: float):
	self.pitch_scale = pitch	

func set_volume(volume_linear: float):
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume_linear))
	else:
		push_error("Audio-Bus 'Music' nicht gefunden!")


func set_muffled(enabled: bool):
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index == -1:
		push_error("Audio-Bus 'Music' nicht gefunden!")
		return

	# Wenn kein Filter existiert, einen hinzufügen
	var filter = AudioEffectLowPassFilter.new()
	filter.cutoff_hz = 800.0 if enabled else 22000.0
	AudioServer.add_bus_effect(bus_index, filter, 0)
	print("filter", filter)

func set_spectrum_analyser(enabled: bool):
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index == -1:
		push_error("Audio-Bus 'Music' nicht gefunden!")
		return

	if enabled:
		# Prüfen, ob Analyzer schon existiert
		for i in range(AudioServer.get_bus_effect_count(bus_index)):
			var effect = AudioServer.get_bus_effect(bus_index, i)
			if effect is AudioEffectSpectrumAnalyzer:
				print("Spectrum Analyzer bereits vorhanden.")
				return

		# Neuen Analyzer hinzufügen
		var analyzer = AudioEffectSpectrumAnalyzer.new()
		analyzer.buffer_length = 1024
		analyzer.tap_back_pos = 0.1
		AudioServer.add_bus_effect(bus_index, analyzer, 0)
		print("Spectrum Analyzer aktiviert.")
	else:
		# Entfernen, wenn vorhanden
		for i in range(AudioServer.get_bus_effect_count(bus_index)):
			var effect = AudioServer.get_bus_effect(bus_index, i)
			if effect is AudioEffectSpectrumAnalyzer:
				AudioServer.remove_bus_effect(bus_index, i)
				print("Spectrum Analyzer deaktiviert.")
				return

func get_bass_magnitude() -> float:
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index == -1:
		return 0.0

	for i in range(AudioServer.get_bus_effect_count(bus_index)):
		var effect = AudioServer.get_bus_effect(bus_index, i)
		if effect is AudioEffectSpectrumAnalyzer:
			var instance = AudioServer.get_bus_effect_instance(bus_index, i)
			if instance:
				var result: Vector2 = instance.get_magnitude_for_frequency_range(20, 250, 1)
				# result.x ist die Magnitude in dB → Umwandeln in linearen Wert
				var magnitude_linear = db_to_linear(result.x)
				return magnitude_linear
	return 0.0

func _on_pause_toggled(paused: bool):
	if paused:
		volume_db = original_volume_db - 10  # Lautstärke absenken
		print("Pause aktiviert:", volume_db)
	else:
		volume_db = original_volume_db
		print("Pause deaktiviert:", volume_db)
