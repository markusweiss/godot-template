# In der Main-Szene (Main.gd)
extends Node2D

@export var fliege_scene : PackedScene = preload("res://features/Enemys/fly.tscn")
@export var min_spawn_time : float = 0.8
@export var max_spawn_time : float = 1.5

func _ready():
	randomize()
	$Panel/SpawnFlyTimer.timeout.connect(_spawn_fliege)
	$Panel/SpawnFlyTimer.start(randf_range(min_spawn_time, max_spawn_time))

func _spawn_fliege():
	var fliege = fliege_scene.instantiate()
	fliege.input_pickable = true  # Explizit aktivieren
	add_child(fliege)
	fliege.fly_clicked.connect(_on_fly_clicked)
	
	fliege.input_pickable = true
	fliege.monitoring = true
	fliege.monitorable = true
	
	print("Fliege instanziiert, Pickable:", fliege.input_pickable)
	
	#fliege.connect("clicked", Callable(self, "_on_input_event"))
	$Panel/SpawnFlyTimer.start(randf_range(min_spawn_time, max_spawn_time))  # Neuen Timer mit zufälliger Zeit starten

func _on_fly_clicked():
	print("Fliege geklickt (via Signal)")
	# Punkte addieren etc.
