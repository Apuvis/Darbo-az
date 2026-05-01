extends CanvasLayer

@onready var yazi_etiketi = $cerceve/yazi_etiketi

func _ready():
	hide()
	# Oyun dondurulsa bile bu scriptin tıklamaları dinlemesi için:
	process_mode = Node.PROCESS_MODE_ALWAYS

func goster(metin: String):
	yazi_etiketi.text = metin
	show()
	# Ekrana yazı çıktığı an TÜM OYUNU DONDUR!
	get_tree().paused = true

func kapat():
	hide()
	# Kutu kapandığı an OYUNU GERİ BAŞLAT!
	get_tree().paused = false

# SOL TIKLAMAYI DİNLEYEN FONKSİYON (Geri geldi!)
func _input(event):
	if visible and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Ana sahnedeki (parent) diyalog ilerletme fonksiyonunu çağır
		if get_parent().has_method("diyalog_ilerlet"):
			get_parent().diyalog_ilerlet()
