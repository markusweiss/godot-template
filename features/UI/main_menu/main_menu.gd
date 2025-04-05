extends CanvasLayer

var test_level_scene:PackedScene = preload("res://features/levels/test_fly_game.tscn")
var test_level = null


func _ready():
	%Version.text = " Version: " + str(Globals.VERSION)
	AudioSettings.apply_saved_audio_settings()

# Temp remove only for testing
func start_test_level():
	if not test_level:
		queue_free()
		test_level = test_level_scene.instantiate()
		get_tree().root.add_child(test_level)
	else:
		push_warning('Test Level already exists in this scene')


func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_settings_pressed():
	Globals.open_settings_menu()


func _on_button_start_pressed():
	start_test_level()
