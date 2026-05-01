extends Control

# Eğer sahnelerin tam yolları farklıysa res:// dizininden sürükleyip buraya güncelleyebilirsin.
var main_scene_path = "res://scene/main_scene.tscn"
var ayarlar_scene_path = "res://scene/ayarlar.tscn"

# 1. OYUNU BAŞLAT BUTONU (Üstteki Area2D)
func _on_area_2d_input_event(viewport, event, shape_idx):
	# Sadece sol fare tuşuna basıldığında tetiklensin
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Oyuna geçiliyor...")
		get_tree().change_scene_to_file("res://scene/main_scene.tscn")

# 2. AYARLAR BUTONU (Ortadaki Area2D - İsmi fonksiyonla eşleşmeli)
func _on_area_2d_2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Ayarlar menüsü açılıyor...")
		get_tree().change_scene_to_file("res://scene/ayarlar.tscn")

# 3. ÇIKIŞ BUTONU (Alttaki Area2D - İsmi fonksiyonla eşleşmeli)
func _on_area_2d_3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Oyundan çıkılıyor...")
		get_tree().quit()
