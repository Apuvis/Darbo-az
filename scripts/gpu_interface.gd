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
	# 1. TEMİZLİK: Bütün MEVCUT yazıları gizli, bütün BUTONLAR açık!
	%LblMevcut1.visible = false
	%LblMevcut2.visible = false
	%LblMevcut3.visible = false
	
	%Btn1.visible = true
	%Btn2.visible = true
	%Btn3.visible = true

	# 2. GPU SEVİYE KONTROLLERİ (Değiş-Tokuş)
	if Global.gpu_level == 2:
		%Btn1.visible = false       
		%LblMevcut1.visible = true  # "GRAFİK HIZI ARTIRILDI"
		
	elif Global.gpu_level == 3:
		%Btn1.visible = false
		%Btn2.visible = false
		%LblMevcut2.visible = true  # "VRAM EKLENDİ"
		
	elif Global.gpu_level >= 4:
		%Btn1.visible = false
		%Btn2.visible = false
		%Btn3.visible = false
		%LblMevcut3.visible = true  # "MAKSİMUM GÜÇ"

# --- BUTON TIKLAMALARI ---
func _on_btn_1_pressed() -> void:
	if Global.gpu_level == 1 and Global.toplanan_bocek >= bedel_1:
		Global.toplanan_bocek -= bedel_1
		Global.gpu_level += 1
		ekrani_tazele()

func _on_btn_2_pressed() -> void:
	if Global.gpu_level == 2 and Global.toplanan_bocek >= bedel_2:
		Global.toplanan_bocek -= bedel_2
		Global.gpu_level += 1
		ekrani_tazele()

func _on_btn_3_pressed() -> void:
	if Global.gpu_level == 3 and Global.toplanan_bocek >= bedel_3:
		Global.toplanan_bocek -= bedel_3
		Global.gpu_level += 1
		ekrani_tazele()

# --- ÇIKIŞ ---
func _on_btn_cikis_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/main_scene.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_btn_cikis_pressed()
