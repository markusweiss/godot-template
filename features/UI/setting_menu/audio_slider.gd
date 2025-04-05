#extends HSlider
#
#@export var bus_name: String
#@export var default_value: float = 1.0
#
#var bus_index: int
#
#func _ready():
	#bus_index = AudioServer.get_bus_index(bus_name)
	#value_changed.connect(_on_value_changed)
#
	## Default value
	#value = default_value
	#
	## Use value on audio bus
	#AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
#
#func _on_value_changed(new_value: float):
	#print(new_value)
	#AudioServer.set_bus_volume_db(
		#bus_index,
		#linear_to_db(new_value)
	#)

extends HSlider

@export var bus_name: String
@export var default_value: float = 1.0

var bus_index: int
const SETTINGS_PATH := "user://settings.cfg"

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)

	# Lade gespeicherten Wert oder verwende default
	var config = ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		print("pfad ok")
		value = config.get_value("audio", bus_name, default_value)
	else:
		print("default")
		value = default_value

	# Wende den Wert auf den Audio-Bus an
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_value_changed(new_value: float):
	# Lautstärke ändern
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))

	# Speichern
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	if err != OK:
		print("Erstelle neue Konfigurationsdatei")
	
	# Setze aktuellen Wert
	config.set_value("audio", bus_name, new_value)
	config.save(SETTINGS_PATH)

	print("Gespeichert:", bus_name, new_value)
