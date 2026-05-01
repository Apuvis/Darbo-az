extends CharacterBody2D

var hiz = 300.0
var hizlanma = 1500.0
var surtunme = 1200.0

func _physics_process(delta):
	var yon = Input.get_vector("a", "d", "w", "s")
	
	if yon != Vector2.ZERO:
		velocity = velocity.move_toward(yon * hiz, hizlanma * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, surtunme * delta)

	move_and_slide()
	
	# Ekran Sınırları
	var ekran_boyutu = get_viewport_rect().size
	position.x = clamp(position.x, 0, ekran_boyutu.x)
	position.y = clamp(position.y, 0, ekran_boyutu.y)
