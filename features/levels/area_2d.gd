extends Area2D

func _ready():
	# Verbinde das area_entered Signal
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if not $CollisionShape2D.disabled:
		print("Treffer mit Area: ", area.name)
		area.queue_free()
