extends Node

const SETTINGS_PATH := "user://settings.cfg"
const BUS_NAMES := ["Master", "Music", "SFX"]

func apply_saved_audio_settings():
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	
	if err != OK:
		print("Keine gespeicherten Einstellungen gefunden. Verwende Defaults.")
	
	for bus_name in BUS_NAMES:
		var volume = config.get_value("audio", bus_name, 1.0) # Default 1.0
		var bus_index = AudioServer.get_bus_index(bus_name)

		if bus_index == -1:
			push_error("Bus '%s' nicht gefunden!" % bus_name)
			continue

		AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
		print("Lade %s Volume: %.2f" % [bus_name, volume])
