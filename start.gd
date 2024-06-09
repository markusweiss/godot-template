extends CanvasLayer

var start_main_menu_scene:PackedScene = preload("res://features/UI/main_menu/main_menu.tscn")
var start_main_menu = null

func _ready():
	open_main_menu()

# temp perhaps remove
func open_main_menu():
	if not start_main_menu:
		print("open menu")
		start_main_menu = start_main_menu_scene.instantiate()
		#get_tree().root.add_child(start_main_menu)
		get_tree().root.add_child.call_deferred(start_main_menu)
	else:
		push_warning('settings menu already exists in this scene')
