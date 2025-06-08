extends CanvasLayer

func _ready():
	%Version.text = " Version: " + str(Globals.VERSION)
	AudioSettings.apply_saved_audio_settings()
	
	var saved_res = SettingsManager.get_setting("display", "resolution", Vector2i(1920, 1080))
	var is_fullscreen = SettingsManager.get_setting("display", "fullscreen", false)
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	if not is_fullscreen:
		apply_resolution(saved_res)
	
func apply_resolution(resolution: Vector2i) -> void:
	DisplayServer.window_set_size(resolution)
	var screen_size = DisplayServer.screen_get_size()
	var center_pos = (screen_size - resolution) / 2
	DisplayServer.window_set_position(center_pos)	

func _on_button_quit_pressed():
	get_tree().quit()

func _on_button_settings_pressed():
	SceneManager.open_settings_menu()

func _on_button_start_pressed():
	SceneManager.start_test_level()
