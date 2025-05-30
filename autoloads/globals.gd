extends Node

const VERSION : float = 0.13

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

var main_menu_scene:PackedScene = preload("res://features/UI/main_menu/main_menu.tscn")
var main_menu = null

var settings_menu_scene:PackedScene = preload("res://features/UI/setting_menu/assets_menu.tscn")
var settings_menu = null

var test_level_scene:PackedScene = preload("res://features/levels/test_fly_game.tscn")
var test_level = null

 
func _ready():
	pass
	

func open_main_menu():
	if not main_menu:
		print("open menu")
		main_menu = main_menu_scene.instantiate()
		#get_tree().root.add_child(main_menu)
		get_tree().root.add_child.call_deferred(main_menu)
	else:
		push_warning('Main menu already exists in this scene')


# temp perhaps remove
func open_settings_menu():
	if not settings_menu:
		settings_menu = settings_menu_scene.instantiate()
		#get_tree().root.add_child(settings_menu)
		get_tree().root.add_child.call_deferred(settings_menu)
	else:
		push_warning('settings menu already exists in this scene')

func start_test_level():
	if not test_level:
		var background = get_tree().root.get_node("Start/Panel")
		background.hide()
		
		if main_menu:
			main_menu.queue_free()
			main_menu = null
		test_level = test_level_scene.instantiate()
		#get_tree().root.add_child(test_level)
		get_tree().root.add_child.call_deferred(test_level)
	else:
		push_warning("Test Level already exists in this scene")
