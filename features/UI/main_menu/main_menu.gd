extends CanvasLayer

var start_player_scene:PackedScene = preload("res://features/levels/test_level.tscn")
var start_player = null


func _ready():
	%Version.text = " Version: " + str(Globals.VERSION)

# Temp remove only for testing
func start_player_win():
	if not start_player:
		queue_free()
		start_player = start_player_scene.instantiate()
		get_tree().root.add_child(start_player)
	else:
		push_warning('player already exists in this scene')


func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_settings_pressed():
	Globals.open_settings_menu()


func _on_button_start_pressed():
	start_player_win()
