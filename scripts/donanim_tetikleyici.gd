extends Area2D

@export_file("*.tscn") var hedef_sahne: String

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# DEBUG: Terminale bak, burada ne yazdığını gör
	print("Tetikleyiciye giren nesne: ", body.name)
	
	# ÇÖZÜM: Player sahnesine gidip Node > Groups kısmından 'player' eklemeyi unutma!
	if body.is_in_group("player"):
		if hedef_sahne != "":
			get_tree().change_scene_to_file(hedef_sahne)
		else:
			print("HATA: Hedef sahne seçilmemiş!")
