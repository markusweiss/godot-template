extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	%Version.text = " Version: " + str(Globals.VERSION)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_quit_pressed():
	get_tree().quit()
