extends CanvasLayer

@onready var fullscreen_checkbox = $MarginContainer/Panel/VBoxContainer/GridContainer/FullscreenCheckBox
@onready var resolution_option_button = $MarginContainer/Panel/VBoxContainer/GridContainer/OptionButton

var available_resolutions: Array[Vector2i] = []
var selected_resolution: Vector2i

func _ready():
	# Auflösungen vorbereiten
	available_resolutions = get_platform_resolutions()
	available_resolutions = remove_duplicates(available_resolutions)
	available_resolutions.sort_custom(func(a, b): return a.x * a.y > b.x * b.y)

	# Dropdown befüllen
	for res in available_resolutions:
		resolution_option_button.add_item("%d x %d" % [res.x, res.y])

	# Einstellungen laden
	var saved_res = SettingsManager.get_setting("display", "resolution", Vector2i(1280, 720))
	var is_fullscreen = SettingsManager.get_setting("display", "fullscreen", false)
	selected_resolution = saved_res

	# Fenster konfigurieren
	if not is_fullscreen:
		apply_resolution(saved_res)

	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_checkbox.button_pressed = is_fullscreen

	# Auswahl im Dropdown setzen
	for i in range(available_resolutions.size()):
		if available_resolutions[i] == saved_res:
			resolution_option_button.select(i)
			break

	# Signals verbinden
	fullscreen_checkbox.toggled.connect(_on_fullscreen_checkbox_toggled)
	resolution_option_button.item_selected.connect(_on_resolution_option_button_item_selected)


func get_platform_resolutions() -> Array[Vector2i]:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	if OS.get_name() == "macOS":
		return [
			screen_size,
			(screen_size * 0.875).floor(),
			(screen_size * 0.75).floor(),
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


# Korrigierte Methode: Entfernt Duplikate aus einem Array von Vector2i
func remove_duplicates(arr: Array) -> Array[Vector2i]:
	var seen := {}
	var result: Array[Vector2i] = []  # Array explizit als Vector2i definieren
	for res in arr:
		if not seen.has(res):  # Verwende direkt den Vector2i als Key
			seen[res] = true
			result.append(res)  # Füge nur einzigartige Werte hinzu
	# Rückgabe eines Arrays vom Typ Vector2i
	return result


func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED)

	if not toggled_on:
		apply_resolution(selected_resolution)

	# Einstellung speichern
	SettingsManager.set_setting("display", "fullscreen", toggled_on)


func _on_resolution_option_button_item_selected(index: int) -> void:
	selected_resolution = available_resolutions[index]

	if not fullscreen_checkbox.button_pressed:
		apply_resolution(selected_resolution)

	# Einstellung speichern
	SettingsManager.set_setting("display", "resolution", selected_resolution)


func apply_resolution(resolution: Vector2i) -> void:
	DisplayServer.window_set_size(resolution)
	var screen_size = DisplayServer.screen_get_size()
	var center_pos = (screen_size - resolution) / 2
	DisplayServer.window_set_position(center_pos)


func _on_button_pressed():
	queue_free()  # Optional: Fenster oder Menü schließen
