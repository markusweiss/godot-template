extends Node

@onready var pause_label = $CenterContainer/Label

signal pause_toggled(paused: bool)

var is_paused: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	connect("pause_toggled", Callable(AudioManager, "on_pause_toggled"))	
	pause_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	pause_label.visible = is_paused

	emit_signal("pause_toggled", is_paused)
	print("Pause:", is_paused)
