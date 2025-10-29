extends Area2D

signal picked_up
@export var weapon_name = "Tirachinas"

func _ready():
	# Conectar la señal cuando un cuerpo entra en el área
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Max" or body.is_in_group("player"):
		# El jugador recoge el arma
		body.pickup_weapon(weapon_name)
		get_parent().call_deferred("queue_free")
