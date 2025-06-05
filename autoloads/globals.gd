extends Node

const VERSION: float = 0.15

@onready var SFX_BUS_ID: int = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID: int = AudioServer.get_bus_index("Music")
