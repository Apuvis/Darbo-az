extends Node2D

@onready var sol_raket = $SolRaket
@onready var sag_raket = $SagRaket
@onready var top = $Top
@onready var mesaj_etiketi = $Label

# --- DENGELİ AYARLAR (NORMAL ZORLUK) ---
const RAKET_HIZI = 500.0
const TOP_HIZI = 750.0      
const BOT_HIZI = 350.0      # Eskiden 110'du, şimdi daha çevik
const BOT_HATA_PAYI = 15.0  # Eskiden 80'di, artık topu ıskalamıyor

var top_yonu = Vector2.ZERO
var oyun_aktif = true

func _ready():
	mesaj_etiketi.text = ""
	randomize()
	var x_yon = 1 if randf() > 0.5 else -1
	top_yonu = Vector2(x_yon, randf_range(-0.6, 0.6)).normalized()

func _process(_delta):
	if !oyun_aktif: return
	# Esc ile Çıkış
	if Input.is_action_just_pressed("ui_cancel"):
		oyunu_bitir("pes_etti")

func _physics_process(delta):
	if not oyun_aktif: return
	var ekran_yuksekligi = get_viewport_rect().size.y

	# --- 1. OYUNCU HAREKETİ ---
	var yon = Input.get_axis("sol_yukari", "sol_asagi")
	sol_raket.velocity.y = yon * RAKET_HIZI
	sol_raket.move_and_slide()
	sol_raket.global_position.y = clamp(sol_raket.global_position.y, 50, ekran_yuksekligi - 50)

	# --- 2. BOT HAREKETİ (NORMAL MOD) ---
	# Bot artık top sahanın ortasını geçtiğinde değil, her zaman takipte
	var fark = top.global_position.y - sag_raket.global_position.y
	if abs(fark) > BOT_HATA_PAYI:
		sag_raket.velocity.y = sign(fark) * BOT_HIZI
	else:
		sag_raket.velocity.y = 0
	
	sag_raket.move_and_slide()
	sag_raket.global_position.y = clamp(sag_raket.global_position.y, 50, ekran_yuksekligi - 50)

	# --- 3. TOP VE KUSURSUZ SEKME ---
	var carpisma = top.move_and_collide(top_yonu * TOP_HIZI * delta)
	if carpisma:
		var nesne = carpisma.get_collider()
		if nesne == sol_raket:
			top_yonu = Vector2(1.0, randf_range(-0.8, 0.8)).normalized()
			top.global_position.x += 15.0 # İçine girip yavaşlamasını önler
		elif nesne == sag_raket:
			top_yonu = Vector2(-1.0, randf_range(-0.8, 0.8)).normalized()
			top.global_position.x -= 15.0 
		else:
			top_yonu = top_yonu.bounce(carpisma.get_normal()).normalized()

	# --- 4. GOL KONTROLÜ ---
	var en = get_viewport_rect().size.x
	if top.global_position.x < 0:
		oyunu_bitir("kaybettin")
	elif top.global_position.x > en:
		oyunu_bitir("kazandin")

# --- ÖDÜL VE BİTİŞ ---
func oyunu_bitir(sebep):
	if !oyun_aktif: return
	oyun_aktif = false
	
	var mesaj = ""
	var kazanilan_bocek = 0

	if sebep == "kazandin":
		kazanilan_bocek = 20
		mesaj = "KAZANDIN!\n+20 BÖCEK"
		Global.ilerleme_ekle(1.5) 
	elif sebep == "kaybettin":
		kazanilan_bocek = 5
		mesaj = "KAYBETTİN...\n+5 BÖCEK"
		Global.ilerleme_ekle(0.2)
	else:
		mesaj = "ÇIKILDI!"

	mesaj_etiketi.text = mesaj
	mesaj_etiketi.modulate = Color.YELLOW
	Global.bocek_ekle(kazanilan_bocek)
	top_yonu = Vector2.ZERO
	
	# quit() yerine ANA SAHNEYE dönüyoruz
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scene/main_scene.tscn")
