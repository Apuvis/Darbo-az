extends Area2D

var hucre_boyutu = 32 
var yon = Vector2.RIGHT
var sonraki_yon = Vector2.RIGHT
var govde_dokusu = preload("res://assets/yilanblok.png")

var kuyruk = [] 
var toplanan_elma = 0 
var oyun_bitti = false # Yılanın durması için kontrol

func _ready():
	# İç pikselleri 320x320'ye sabitler
	get_viewport().content_scale_size = Vector2i(320, 320)
	print("Yılan oyunu 320x320 modunda başlatıldı.")

func _process(_delta):
	if oyun_bitti: return # Oyun bittiyse tuşları okumayı bırak

	# Hareket kontrolleri
	if Input.is_action_just_pressed("w") and yon != Vector2.DOWN:
		sonraki_yon = Vector2.UP
	elif Input.is_action_just_pressed("s") and yon != Vector2.UP:
		sonraki_yon = Vector2.DOWN
	elif Input.is_action_just_pressed("a") and yon != Vector2.RIGHT:
		sonraki_yon = Vector2.LEFT
	elif Input.is_action_just_pressed("d") and yon != Vector2.LEFT:
		sonraki_yon = Vector2.RIGHT

	# İstenildiği an Esc ile çıkış yapıp parayı alma
	if Input.is_action_just_pressed("ui_cancel"):
		oyunu_bitir("pes_etti")

func _on_timer_timeout():
	if oyun_bitti: return # Oyun bittiyse yılanı ilerletme
	
	var eski_konum = position
	
	yon = sonraki_yon
	position += yon * hucre_boyutu
	
	# Kafayı Döndürme
	$Sprite2D.rotation = yon.angle()
	
	# Kuyruk takibi
	if kuyruk.size() > 0:
		for i in range(kuyruk.size() - 1, 0, -1):
			kuyruk[i].position = kuyruk[i - 1].position
		kuyruk[0].position = eski_konum
		
	# Duvara Çarpma Kontrolü (320x320 ekrana göre hesaplandı)
	if position.x < 0 or position.x >= 320 or position.y < 0 or position.y >= 320:
		oyunu_bitir("duvar")
		
	# Kendi Kuyruğuna Çarpma Kontrolü
	for parca in kuyruk:
		if position == parca.position:
			oyunu_bitir("kuyruk")

func _on_area_entered(area):
	if area.name == "Elma":
		area.rastgele_yerlestir()
		kuyruk_uzat()
		
		# Elma sayacı artar
		toplanan_elma += 1 
		print("Elma yendi! Toplam: ", toplanan_elma)

func kuyruk_uzat():
	var yeni_parca = Sprite2D.new()
	yeni_parca.texture = govde_dokusu
	yeni_parca.centered = false
	
	var resim_boyutu = govde_dokusu.get_size()
	yeni_parca.scale = Vector2(hucre_boyutu / resim_boyutu.x, hucre_boyutu / resim_boyutu.y)
	
	yeni_parca.position = Vector2(-100, -100)
	get_parent().add_child(yeni_parca)
	kuyruk.append(yeni_parca)

# --- ÖDÜL, ÇIKIŞ VE EKRAN YAZISI SİSTEMİ ---
func oyunu_bitir(sebep):
	if oyun_bitti: return # İki kere çalışmasını engeller
	oyun_bitti = true
	
	var kazanilan_bocek = toplanan_elma * 3
	
	if sebep == "duvar" or sebep == "kuyruk":
		print("YILAN ÖLDÜ! Kazanılan Böcek: ", kazanilan_bocek)
	elif sebep == "pes_etti":
		print("ÇIKILDI! Kazanılan Böcek: ", kazanilan_bocek)

	# --- 1. EKRANA YAZI ÇIKARMA İŞLEMİ ---
	var canvas = CanvasLayer.new() 
	add_child(canvas)
	
	var yazi = Label.new()
	if sebep == "pes_etti":
		yazi.text = "KASA TOPLANDI!\n+" + str(kazanilan_bocek) + " BÖCEK KAZANDIN"
	else:
		yazi.text = "OYUN BİTTİ!\n+" + str(kazanilan_bocek) + " BÖCEK KAZANDIN"
		
	# Yazıyı özelleştirme
	yazi.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	yazi.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	yazi.add_theme_font_size_override("font_size", 30)
	yazi.add_theme_color_override("font_color", Color.YELLOW)
	yazi.add_theme_color_override("font_outline_color", Color.BLACK)
	yazi.add_theme_constant_override("outline_size", 12)
	
	# Tam ekranın ortasına sabitleme
	yazi.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(yazi)

	# --- 2. ARKA PLANDAKİ MATEMATİK (Ekonomi) ---
	Global.bocek_ekle(kazanilan_bocek)
	Global.ilerleme_ekle(0.5) # Eskiden 5.0'dı, şimdi 10'da 1'ine düştü!
	
	# --- 3. 2 SANİYE BEKLE VE ANA SAHNEYE DÖN ---
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scene/main_scene.tscn")
