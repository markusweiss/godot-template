extends CanvasLayer

const BUS_NAMES := ["Master", "Music", "SFX"]

func _ready():
	var menu_music = preload("res://features/UI/main_menu/assets/sounds/templateloop.mp3")
	AudioManager.play_music(menu_music)
	AudioManager.set_muffled(false)
	menu_music.loop = true
	
	%Version.text = " Template Version: " + str(Globals.VERSION)
	apply_saved_audio_settings()
	
	var saved_res = SettingsManager.get_setting("display", "resolution", Vector2i(1280, 720))
	var is_fullscreen = SettingsManager.get_setting("display", "fullscreen", false)
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	if not is_fullscreen:
		apply_resolution(saved_res)
	
func apply_resolution(resolution: Vector2i) -> void:
	DisplayServer.window_set_size(resolution)
	var screen_size = DisplayServer.screen_get_size()
	var center_pos = (screen_size - resolution) / 2
	DisplayServer.window_set_position(center_pos)
	
func apply_saved_audio_settings():
	var config = ConfigFile.new()
	var err = config.load(Globals.SETTINGS_PATH)
	
	if err != OK:
		print("Keine gespeicherten Einstellungen gefunden. Verwende Defaults.")
	
	for bus_name in BUS_NAMES:
		var volume = config.get_value("audio", bus_name, 0.7) # Default 0.7
		var bus_index = AudioServer.get_bus_index(bus_name)

		if bus_index == -1:
			push_error("Bus '%s' nicht gefunden!" % bus_name)
			continue

		AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
		print("Lade %s Volume: %.2f" % [bus_name, volume])

func _on_button_quit_pressed():
	get_tree().quit()

func _on_button_settings_pressed():
	SceneManager.open_settings_menu()

func _on_button_start_pressed():
	SceneManager.start_test_level()
