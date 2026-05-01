extends ColorRect

# Yılanın kutularıyla aynı boyutta olmalı
var izgara_boyutu = 32
# Çizgilerin rengi (Şu an yarı saydam beyaz/gri bir renk)
var cizgi_rengi = Color(1.0, 1.0, 1.0, 0.2) 

func _draw():
	# Dikey çizgileri çiz
	for x in range(0, int(size.x), izgara_boyutu):
		draw_line(Vector2(x, 0), Vector2(x, size.y), cizgi_rengi, 1.0)
		
	# Yatay çizgileri çiz
	for y in range(0, int(size.y), izgara_boyutu):
		draw_line(Vector2(0, y), Vector2(size.x, y), cizgi_rengi, 1.0)
