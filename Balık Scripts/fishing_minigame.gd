extends Node2D

# Düğümleri Koda Tanıtma
@onready var bg = $Background
@onready var green = $Background/GreenArea
@onready var fish = $Background/Fish
@onready var label = $Label

# Ayarlar ve Değişkenler
var bar_height = 200.0
var green_height = 50.0
var green_pos = 0.0
var green_velocity = 0.0

var fish_pos = 50.0
var fish_target_pos = 50.0
var fish_speed = 2.0

var game_timer = 10.0 # Süreyi biraz uzattım ki yakalamak için vakit olsun
var is_game_over = false

# --- STARDEW VALLEY MEKANİĞİ İÇİN YENİ DEĞİŞKENLER ---
var yakalama_ilerlemesi = 20.0 # 0 ile 100 arası. %20'den (avans) başlasın
var artis_hizi = 25.0 # Balık barın içindeyken saniyede %25 dolar
var dusus_hizi = 15.0 # Balık dışarıdayken saniyede %15 düşer

func _ready():
	bar_height = bg.size.y
	green_height = green.size.y
	green.position.x = 0
	fish.position.x = 2
	label.text = "Hazır Ol!"

func _process(delta):
	if is_game_over: return

	# 1. Süre Kontrolü
	game_timer -= delta

	# 2. Yeşil Alan (Oyuncu) Kontrolü (Space Tuşu)
	if Input.is_action_pressed("ui_select"): 
		green_velocity -= 800.0 * delta
	else:
		green_velocity += 600.0 * delta
		
	green_pos += green_velocity * delta
	
	# Sınırların dışına çıkmasını engelle
	green_pos = clamp(green_pos, 0, bar_height - green_height)
	if green_pos <= 0 or green_pos >= bar_height - green_height:
		green_velocity = 0

	# 3. Balık (Yapay Zeka) Hareketi
	if abs(fish_pos - fish_target_pos) < 5:
		fish_target_pos = randf_range(0, bar_height - fish.size.y)
	
	fish_pos = lerp(fish_pos, fish_target_pos, delta * fish_speed)

	# 4. Görselleri Güncelle
	green.position.y = green_pos
	fish.position.y = fish_pos

	# --- 5. YENİ: STARDEW YAKALAMA MANTIĞI ---
	# Balık yeşil alanın tam içinde mi?
	var balik_icerde_mi = fish_pos >= green_pos and fish_pos <= (green_pos + green_height)
	
	if balik_icerde_mi:
		yakalama_ilerlemesi += artis_hizi * delta
		green.modulate = Color.GREEN # İçerdeyken oyuncunun barı yeşil parlasın (görsel destek)
	else:
		yakalama_ilerlemesi -= dusus_hizi * delta
		green.modulate = Color.WHITE # Dışardayken normale dönsün
		
	# Değeri 0 ile 100 arasında sınırla
	yakalama_ilerlemesi = clamp(yakalama_ilerlemesi, 0.0, 100.0)
	
	# Ekrana anlık yüzdeyi yazdırıyoruz
	label.text = "Yakalama: %" + str(int(yakalama_ilerlemesi)) + "\nKalan Süre: " + str(int(game_timer))

	# 6. SONUÇ KONTROLLERİ (Kazanma / Kaybetme)
	# Yüzde 100 olursa beklemeden kazanırsın!
	if yakalama_ilerlemesi >= 100.0:
		oyunu_bitir("kazandin")
	# Süre biterse veya yakalama oranın %0'a vurursa kaybedersin
	elif game_timer <= 0 or yakalama_ilerlemesi <= 0.0:
		oyunu_bitir("kaybettin")

# --- ÖDÜL VE BİTİŞ ---
# fishing_minigame.gd içindeki oyunu_bitir fonksiyonu
func oyunu_bitir(durum):
	is_game_over = true
	
	if durum == "kazandin":
		label.text = "BUG'U YAKALADIN!\n+5 BÖCEK"
		Global.bocek_ekle(5) 
		Global.ilerleme_ekle(3.0) # Eskiden 30.0 idi
	else:
		label.text = "KAÇTI...\n+1 BÖCEK"
		Global.bocek_ekle(1)
		Global.ilerleme_ekle(0.5) # Eskiden 5.0 idi

	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scene/main_scene.tscn")
