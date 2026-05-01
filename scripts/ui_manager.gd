extends Control # Eğer UI ana düğümün bir CanvasLayer ise burayı "extends CanvasLayer" yap.

# --- 1. EKRANDAKİ DÜĞÜMLERİ ÇAĞIRMA ---
@onready var progress_bar = $ProgressBar 
@onready var uyumluluk_bari = $HarmonyBar 
@onready var sayi_label = $HBoxContainer/SayiLabel 

# --- 2. MOTORUN KALBİ (Saniyede 60 kere çalışır) ---
func _process(_delta):
	
	# A. İlerleme Barını Bağla
	if progress_bar:
		progress_bar.value = Global.progress
		
	# B. Darboğaz (Uyumluluk) Barını Bağla
	if uyumluluk_bari:
		uyumluluk_bari.value = Global.uyumluluk_yuzdesi
		
		# Görsel Cila: Uyumluluk %50'nin altına düşerse bar kırmızıya dönsün!
		if Global.uyumluluk_yuzdesi < 50:
			uyumluluk_bari.modulate = Color(1, 0.2, 0.2) # Kırmızı alarm
		else:
			uyumluluk_bari.modulate = Color(1, 1, 1) # Normal
			
	# C. Kasadaki Parayı (Böceği) Yazıya Bağla
	if sayi_label:
		sayi_label.text = ": " + str(Global.toplanan_bocek)
