extends Node

const VERSION: float = 0.16
const SETTINGS_PATH := "user://settings.cfg"

@onready var SFX_BUS_ID: int = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID: int = AudioServer.get_bus_index("Music")
