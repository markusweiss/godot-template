extends Node

@onready var pause_label = $CenterContainer/Label

signal pause_toggled(paused: bool)

var is_paused: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var paused = !get_tree().paused
		get_tree().paused = paused
		pause_label.visible = paused
		
		is_paused = !is_paused
		print("Pause", is_paused)
		emit_signal("pause_toggled", is_paused)
		
