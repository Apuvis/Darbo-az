extends Area2D

var hucre_boyutu = 32

func _ready():
	rastgele_yerlestir()

func rastgele_yerlestir():
	# Sahnedeki yılan kafasını buluyoruz (İsminin SneakHead olduğundan emin ol)
	var yilan = get_parent().get_node("SneakHead")
	
	var yeni_konum = Vector2.ZERO
	var konum_uygun = false
	
	# Uygun bir yer bulana kadar döngü devam eder
	while not konum_uygun:
		konum_uygun = true # Şimdilik uygun varsayıyoruz
		
		# Rastgele ızgara koordinatlarını seç
		var x = randi_range(1, 8) * hucre_boyutu
		var y = randi_range(1, 8) * hucre_boyutu
		yeni_konum = Vector2(x, y)
		
		# 1. Kontrol: Kafanın olduğu yer mi?
		if yeni_konum == yilan.position:
			konum_uygun = false
			continue # Döngünün başına dön, tekrar sayı seç
			
		# 2. Kontrol: Kuyruk parçalarından birinin üstü mü?
		for parca in yilan.kuyruk:
			if yeni_konum == parca.position:
				konum_uygun = false
				break # Bu konum uygun değil, iç döngüden çık
				
	# Döngüden çıkabildiysek temiz bir yer bulmuşuz demektir
	position = yeni_konum
