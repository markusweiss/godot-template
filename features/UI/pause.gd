extends Node


@onready var pause_label = $CenterContainer/Label
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var paused = !get_tree().paused
		get_tree().paused = paused
		pause_label.visible = paused
