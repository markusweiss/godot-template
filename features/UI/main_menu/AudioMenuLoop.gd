extends AudioStreamPlayer2D

func _ready():
	stream = preload("res://features/UI/main_menu/assets/sounds/templateloop.mp3")
	play()
	

func _on_finished():
	play()
