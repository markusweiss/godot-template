extends CanvasLayer

@onready var fullscreen_checkbox = $MarginContainer/Panel/VBoxContainer/GridContainer/FullscreenCheckBox
@onready var resolution_option_button = $MarginContainer/Panel/VBoxContainer/GridContainer/OptionButton

var available_resolutions: Array[Vector2i] = []
var selected_resolution: Vector2i = Vector2i(1920, 1080)

func _ready():
	# Plattformabhängige Auflösungen holen
	available_resolutions = get_platform_resolutions()

	# Optionen im Dropdown füllen
	for res in available_resolutions:
		resolution_option_button.add_item("%d x %d" % [res.x, res.y])

	# Aktuelle Fenstergröße holen und passende Auswahl im Dropdown setzen
	var current_size: Vector2i = DisplayServer.window_get_size()
	for i in range(available_resolutions.size()):
		if available_resolutions[i] == current_size:
			resolution_option_button.select(i)
			selected_resolution = current_size
			break

	# Signals verbinden
	fullscreen_checkbox.toggled.connect(_on_fullscreen_checkbox_toggled)
	resolution_option_button.item_selected.connect(_on_resolution_option_button_item_selected)

	# Fullscreen-Status aktualisieren
	fullscreen_checkbox.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN


func get_platform_resolutions() -> Array[Vector2i]:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	if OS.get_name() == "macOS":
		return [
			screen_size,
			screen_size * 0.875,
			screen_size * 0.75,
			Vector2i(1600, 900),
			Vector2i(1440, 810),
			Vector2i(1280, 720)
		]
	else:
		return [
			screen_size,
			Vector2i(2560, 1440),
			Vector2i(1920, 1080),
			Vector2i(1600, 900),
			Vector2i(1280, 720)
		]


func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(selected_resolution)
		# Fenster zentrieren
		var screen_size = DisplayServer.screen_get_size()
		var center_pos = (screen_size - selected_resolution) / 2
		DisplayServer.window_set_position(center_pos)


func _on_resolution_option_button_item_selected(index: int) -> void:
	selected_resolution = available_resolutions[index]
	if !fullscreen_checkbox.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(selected_resolution)
		var screen_size = DisplayServer.screen_get_size()
		var center_pos = (screen_size - selected_resolution) / 2
		DisplayServer.window_set_position(center_pos)


# Optional: Fenster schließen oder Menü ausblenden
func _on_button_pressed():
	queue_free()
