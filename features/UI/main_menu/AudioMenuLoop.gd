#extends AudioStreamPlayer2D
#
#func _ready():
	#stream = preload("res://features/UI/main_menu/assets/sounds/templateloop.mp3")
	#bus = "Music"
#
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(0.7))
#
	#play()
#
#func _on_finished():
	#play()

extends AudioStreamPlayer2D

const SETTINGS_PATH := "user://settings.cfg"

func _ready():
	stream = preload("res://features/UI/main_menu/assets/sounds/templateloop.mp3")
	bus = "Music"

	# Lade gespeicherten Wert für Music
	var config = ConfigFile.new()
	var volume = 0.7 # fallback default

	if config.load(SETTINGS_PATH) == OK:
		volume = config.get_value("audio", "Music", 0.7)

	# Wende Lautstärke auf Bus an
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index == -1:
		push_error("Audio-Bus 'Music' nicht gefunden!")
	else:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))

	play()


func _on_finished():
	play()
