extends Node

@onready var background = $Panel
var settings_menu: Node = null

func _ready():
	SceneManager.open_main_menu()
