extends Area2D

@export var speed: float = 600
var direction = Vector2.ZERO

func _ready():
	connect("body_entered", _on_body_entered)

func get_damage() -> int:
	return 1
func _process(delta):
	position += direction * speed * delta

	# Elimina la bala si sale de la pantalla
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _on_body_entered(body):
	# Detecta enemigos
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		queue_free() # destruye la bala
