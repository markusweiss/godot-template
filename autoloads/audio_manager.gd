# AudioManager.gd
extends AudioStreamPlayer2D

var pause_node: Node
var original_volume_db: float
var current_stream: AudioStream = null
var lowpass_filter: AudioEffectLowPassFilter = null

# Standard-Bus für Musik
const MUSIC_BUS := "Music"

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.bus = MUSIC_BUS  # sicherstellen, dass die Musik auf dem richtigen Bus spielt
	original_volume_db = volume_db


func play_music(audio_stream: AudioStream):
	if current_stream == audio_stream and playing:
		return
	current_stream = audio_stream
	self.stream = audio_stream
	play()

func stop_music():
	stop()


func set_pitch(pitch: float):
	self.pitch_scale = pitch	


func set_volume(volume: float, bus_name: String = MUSIC_BUS):
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	else:
		push_error("Audio-Bus '%s' nicht gefunden!" % bus_name)


func set_muffled(enabled: bool):
	var bus_index = AudioServer.get_bus_index(MUSIC_BUS)
	if bus_index == -1:
		push_error("Audio-Bus 'Music' nicht gefunden!")
		return

	# Filter einmal erstellen, dann nur Parameter ändern
	if lowpass_filter == null:
		lowpass_filter = AudioEffectLowPassFilter.new()
		AudioServer.add_bus_effect(bus_index, lowpass_filter, 0)

	lowpass_filter.cutoff_hz = 400.0 if enabled else 22000.0
	print("Muffled: ", enabled, "Cutoff: ", lowpass_filter.cutoff_hz)


func on_pause_toggled(paused: bool):
	if paused:
		set_volume(0.7, MUSIC_BUS)  # Musik leiser
		set_muffled(true)           # muffled
	else:
		set_volume(1.0, MUSIC_BUS)  # Musik zurück auf normal
		set_muffled(false)
