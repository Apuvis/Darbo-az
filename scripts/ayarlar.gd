extends Control # YEŞİL ikon olduğu için Control şart

@onready var h_slider = $HSlider

func _ready():
	# Ses seviyesini başlangıçta sistemden alıp slider'a yansıt
	var bus_index = AudioServer.get_bus_index("Master")
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

# --- SİNYAL: HSlider -> value_changed ---
func _on_h_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

# --- SİNYAL: TamEkran/Area2D -> input_event ---
func _on_tam_ekran_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("TAM EKRAN TETIKLENDI")
		var mode = DisplayServer.window_get_mode()
		if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# --- SİNYAL: GeriDon/Area2D -> input_event ---
func _on_geri_don_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("GERI DON TETIKLENDI")
		# call_deferred ile ana menüye güvenli geçiş
		get_tree().call_deferred("change_scene_to_file", "res://scene/main_menu.tscn")
