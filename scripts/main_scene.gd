extends Node2D

var diyalog_asamasi = 0
var sahne_degisiyor = false 

func _ready():
	get_viewport().content_scale_size = Vector2i(1197, 880)

	# Global'deki oyun_bitti sinyalini dinliyoruz
	Global.oyun_bitti.connect(_on_oyun_bitti)

	# Eğer sahne yüklendiğinde bar zaten 100 ise (minigame'den dönüldüyse)
	if Global.progress >= Global.max_progress:
		_on_oyun_bitti()
		return

	if Global.mesaj_gosterildi_mi == false:
		$DiyalogSistemi.goster("Hareket Etmek için 'wasd' tuşlarını kullanın. Devam etmek için 'sol click' tuşunu kullanın.")
		diyalog_asamasi = 1 

func _on_oyun_bitti():
	$DiyalogSistemi.goster("BAŞARDINIZ!")
	diyalog_asamasi = 3

func diyalog_ilerlet():
	if diyalog_asamasi == 1:
		$DiyalogSistemi.kapat() 
		Global.mesaj_gosterildi_mi = true 
		diyalog_asamasi = 0
		
	elif diyalog_asamasi == 3:
		$DiyalogSistemi.kapat()
		# BAŞARDINIZ yazısından sonra direkt video sahnesine geçer
		get_tree().change_scene_to_file("res://scene/bitis.tscn")

func _input(event):
	# Test için 'H' tuşuna basınca processi fuller
	if event is InputEventKey and event.pressed and event.keycode == KEY_H:
		Global.progress = 99.0

# KAPI FONKSİYONLARI 
func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body.name == "player" and not sahne_degisiyor:
		sahne_degisiyor = true
		get_tree().call_deferred("change_scene_to_file", "res://scene/ram_interface.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player" and not sahne_degisiyor:
		sahne_degisiyor = true
		get_tree().call_deferred("change_scene_to_file", "res://scene/gpu_interface.tscn")

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "player" and not sahne_degisiyor:
		sahne_degisiyor = true
		get_tree().call_deferred("change_scene_to_file", "res://scene/cpu_interface.tscn")
