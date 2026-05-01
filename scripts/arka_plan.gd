extends ColorRect

var hucre_boyutu = 32
var capraz_renk = Color(0, 0, 0, 0.2) 
var duvar_rengi = Color(0.8, 0.2, 0.2) 
var duvar_kalinligi = 2

func _draw():
	var sutun_sayisi = int(size.x / hucre_boyutu)
	var satir_sayisi = int(size.y / hucre_boyutu)
	
	for x in range(sutun_sayisi):
		for y in range(satir_sayisi):
			if (x + y) % 2 == 0:
				var kutu_alani = Rect2(x * hucre_boyutu, y * hucre_boyutu, hucre_boyutu, hucre_boyutu)
				draw_rect(kutu_alani, capraz_renk)
				
	draw_rect(Rect2(0, 0, size.x, duvar_kalinligi), duvar_rengi)
	draw_rect(Rect2(0, size.y - duvar_kalinligi, size.x, duvar_kalinligi), duvar_rengi)
	draw_rect(Rect2(0, 0, duvar_kalinligi, size.y), duvar_rengi)
	draw_rect(Rect2(size.x - duvar_kalinligi, 0, duvar_kalinligi, size.y), duvar_rengi)
