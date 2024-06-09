extends CanvasLayer

var main_menu_scene:PackedScene = preload("res://features/UI/main_menu/main_menu.tscn")
var main_menu = null

func _ready():
	open_main_menu()

# temp perhaps remove
func open_main_menu():
	if not main_menu:
		print("open menu")
		main_menu = main_menu_scene.instantiate()
		#get_tree().root.add_child(start_main_menu)
		get_tree().root.add_child.call_deferred(main_menu)
	else:
		push_warning('Main menu already exists in this scene')
