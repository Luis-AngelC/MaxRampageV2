# Este script puede ir en tu Camera2D
extends Camera2D

func _ready():
	zoom = Vector2(1.8, 1.8)  # Zoom inicial
	# Creamos tween para animar el zoom
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(1.2, 1.2), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
