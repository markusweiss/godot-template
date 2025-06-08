extends Node

@onready var root = get_tree().root
@onready var main_menu_scene: PackedScene = preload("res://features/UI/main_menu/main_menu.tscn")
@onready var settings_menu_scene: PackedScene = preload("res://features/UI/settings_menu/settings_menu.tscn")
@onready var test_level_scene: PackedScene = preload("res://features/levels/test_fly_game.tscn")

var test_level: Node = null
var settings_menu: Node = null
var main_menu: Node = null

func _ready() -> void:
	pass

func open_main_menu() -> void:
	if main_menu == null:
		print("Opening main menu")
		main_menu = main_menu_scene.instantiate()
		root.call_deferred("add_child", main_menu)
	else:
		push_warning("Main menu already exists in the scene.")

func open_settings_menu() -> void:
	if settings_menu == null:
		settings_menu = settings_menu_scene.instantiate()
		root.call_deferred("add_child", settings_menu)
	else:
		push_warning("Settings menu already exists in the scene.")

func start_test_level() -> void:
	if test_level == null:
		var background := root.get_node_or_null("Start/Panel")
		if background:
			background.hide()
		
		if main_menu:
			main_menu.queue_free()
			main_menu = null

		test_level = test_level_scene.instantiate()
		root.call_deferred("add_child", test_level)
	else:
		push_warning("Test level already exists in the scene.")
