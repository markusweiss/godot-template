extends CanvasLayer

func _ready():
	%Version.text = " Version: " + str(Globals.VERSION)
	AudioSettings.apply_saved_audio_settings()

func _on_button_quit_pressed():
	get_tree().quit()

func _on_button_settings_pressed():
	SceneManager.open_settings_menu()

func _on_button_start_pressed():
	SceneManager.start_test_level()
