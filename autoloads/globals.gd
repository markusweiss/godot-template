extends Node

const VERSION : float = 0.2

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

var settings_menu_scene:PackedScene = preload("res://features/UI/setting_menu/assets_menu.tscn")
#temp do i need?
var settings_menu = null
 
func _ready():
	pass


# temp perhaps remove
func open_settings_menu():
	if not settings_menu:
		print("open menu")
		settings_menu = settings_menu_scene.instantiate()
		get_tree().root.add_child(settings_menu)
		#get_tree().root.add_child.call_deferred(settings_menu)
	else:
		push_warning('settings menu already exists in this scene')
