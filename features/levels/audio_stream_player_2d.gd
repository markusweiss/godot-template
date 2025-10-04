extends AudioStreamPlayer2D

@export var pause_node_path: NodePath  # im Editor zuweisen
var pause_node: Node

func _ready():
	pause_node = get_node(pause_node_path)
	pause_node.connect("pause_toggled", Callable(self, "_on_pause_toggled"))

func _on_pause_toggled(paused: bool):
	if paused:
		print("Pause aktiviert:", paused)
	else:
		print("Pause deaktiviert:", paused)
