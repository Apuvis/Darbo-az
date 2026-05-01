extends Control

var bedel_1 = 20
var bedel_2 = 50
var bedel_3 = 100

func _ready():
	# Yazıların tıklamayı yutmasını engelliyoruz
	%LblIsim1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	%LblIsim2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	%LblIsim3.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	%LblMevcut1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	%LblMevcut2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	%LblMevcut3.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	ekrani_tazele()

func ekrani_tazele():
	# 1. OYUN BAŞI: Bütün MEVCUT yazıları gizli, bütün BUTONLAR açık!
	%LblMevcut1.visible = false
	%LblMevcut2.visible = false
	%LblMevcut3.visible = false
	
	%Btn1.visible = true
	%Btn2.visible = true
	%Btn3.visible = true

	# 2. SEVİYE KONTROLLERİ (Değiş-Tokuş Başlıyor)
	
	if Global.cpu_level == 2:
		# Sadece 1. Geliştirme alındı
		%Btn1.visible = false       
		%LblMevcut1.visible = true  # 1. Mevcut yazısı açıldı
		
	elif Global.cpu_level == 3:
		# 2. Geliştirme de alındı! (1. Mevcut yazısı gizli kalmaya devam eder)
		%Btn1.visible = false
		%Btn2.visible = false
		%LblMevcut2.visible = true  # Sadece 2. Mevcut yazısı ekranda!
		
	elif Global.cpu_level >= 4:
		# 3. Geliştirme alındı! (Artık CPU fulllendi)
		%Btn1.visible = false
		%Btn2.visible = false
		%Btn3.visible = false
		%LblMevcut3.visible = true  # Sadece 3. Mevcut yazısı ekranda!

# --- BUTON TIKLAMALARI ---
func _on_btn_1_pressed() -> void:
	if Global.cpu_level == 1 and Global.toplanan_bocek >= bedel_1:
		Global.toplanan_bocek -= bedel_1
		Global.cpu_level += 1
		ekrani_tazele()
	else:
		print("Sıranı bekle veya yeterli böcek topla!")

func _on_btn_2_pressed() -> void:
	if Global.cpu_level == 2 and Global.toplanan_bocek >= bedel_2:
		Global.toplanan_bocek -= bedel_2
		Global.cpu_level += 1
		ekrani_tazele()

func _on_btn_3_pressed() -> void:
	if Global.cpu_level == 3 and Global.toplanan_bocek >= bedel_3:
		Global.toplanan_bocek -= bedel_3
		Global.cpu_level += 1
		ekrani_tazele()

# --- ÇIKIŞ ---
func _on_btn_cikis_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/main_scene.tscn")

func _input(event):
	
	
	# HİLE TUŞU: "B" (Bug) tuşuna basınca 600 böcek verir
	if event is InputEventKey and event.pressed and event.keycode == KEY_B:
		Global.toplanan_bocek += 600
		ekrani_tazele() # Arayüzdeki butonların/yazıların güncellenmesi için
		print("HİLE AKTİF: 600 böcek eklendi! Mevcut: ", Global.toplanan_bocek)


	if event.is_action_pressed("ui_cancel"):
		_on_btn_cikis_pressed()
