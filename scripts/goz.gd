extends Sprite2D

# @export komutu bu değişkeni Godot editörüne (sağdaki panele) taşır.
# İstediğimiz bir hedefi (Player) buradan seçeceğiz.
@export var hedef: Node2D 

var takip_hizi = 10.0 

func _process(delta):
	# GÜVENLİK: Eğer editörden bir hedef seçmeyi unutursan oyun çökmesin diye kontrol ediyoruz
	if hedef != null:
		
		# 1. Hedefin (Player) tam konumunu öğren
		var hedef_konumu = hedef.global_position
		
		# 2. Göz ile hedef arasındaki açıyı hesapla
		var hedef_aci = global_position.direction_to(hedef_konumu).angle()
		
		# 3. Gözü o açıya doğru yumuşakça çevir
		rotation = lerp_angle(rotation, hedef_aci, takip_hizi * delta)
