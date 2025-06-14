extends Node

#const SETTINGS_PATH := "user://settings.cfg"

var config := ConfigFile.new()
var is_loaded := false

func _ready():
	load_settings()

func load_settings() -> void:
	var err = config.load(Globals.SETTINGS_PATH)
	if err != OK:
		is_loaded = false
		print("⚠️ SettingsManager: Fehler %d beim Laden der Datei '%s'" % [err, Globals.SETTINGS_PATH])
		return

	is_loaded = true  # Erfolgsfall – kein else nötig

func save_settings() -> void:
	config.save(Globals.SETTINGS_PATH)

func get_setting(section: String, key: String, default_value = null):
	return config.get_value(section, key, default_value)

func set_setting(section: String, key: String, value) -> void:
	config.set_value(section, key, value)
	save_settings()
