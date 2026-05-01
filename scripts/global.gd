extends Node

signal oyun_bitti
var bitis_tetiklendi: bool = false # Sinyalin sürekli fırlatılmasını engellemek için

# --- BİLEŞEN SEVİYELERİ ---
var cpu_level: int = 1
var gpu_level: int = 1
var ram_level: int = 1

# --- BARLAR VE KAYNAKLAR ---
var progress: float = 0.0
var max_progress: float = 100.0
var uyumluluk_yuzdesi: float = 100.0
var progress_carpan: float = 1.0
var toplanan_bocek: int = 0

# --- MESAJ VE KİLİT KONTROLLERİ ---
var mesaj_gosterildi_mi: bool = false
var gpu_minigame_acik: bool = false
var ram_minigame_acik: bool = false

func _process(_delta: float) -> void:
	hesapla_sistem()
	
	# İlerleme 100'e ulaştığı an (nerede olursan ol) bitişi tetikler
	if progress >= max_progress and not bitis_tetiklendi:
		bitis_tetiklendi = true
		oyun_bitti.emit()
		# Oyuncuyu hangi minigame'de olursa olsun ana odaya geri döndürür
		get_tree().call_deferred("change_scene_to_file", "res://scene/main_scene.tscn")

func hesapla_sistem():
	var leveller = [cpu_level, gpu_level, ram_level]
	var max_lvl = leveller.max()
	var min_lvl = leveller.min()
	
	# UYUMLULUK: Seviye farkı arttıkça uyumluluk barı aşağı düşer
	var fark = max_lvl - min_lvl
	uyumluluk_yuzdesi = clamp(100.0 - (fark * 30.0), 10.0, 100.0)
	
	# ÇARPAN: Level 2 sistem Level 1'e göre daha verimli ilerler
	progress_carpan = min_lvl * (uyumluluk_yuzdesi / 100.0)
	
	if cpu_level >= 2: gpu_minigame_acik = true
	if gpu_level >= 2: ram_minigame_acik = true

func ilerleme_ekle(miktar: float):
	progress += miktar * progress_carpan
	progress = clamp(progress, 0, max_progress)

func bocek_ekle(miktar: int):
	toplanan_bocek += miktar
