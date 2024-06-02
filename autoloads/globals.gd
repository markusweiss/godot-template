extends Node

const VERSION : float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
