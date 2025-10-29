extends CharacterBody2D

@export var speed: float = 80.0
@export var health: int = 5
@export var damage: int = 1
@export var attack_cooldown: float = 1.0

var player: Node2D = null
var can_attack: bool = true

func _ready() -> void:
	# Busca al jugador usando su grupo "player"
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_warning("No se encontró el jugador en el grupo 'player'.")

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func _on_attack_area_body_entered(body: Node) -> void:
	if body.is_in_group("player") and can_attack:
		if body.has_method("recibir_dano"):
			body.recibir_dano(1)
		else:
			push_warning("El jugador no tiene el método 'take_damage'")
		
		can_attack = false
		# Esperar el tiempo de cooldown antes de volver a atacar
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func take_damage(amount: int) -> void:
	health -= amount
	print("slime recibio daño")
	if health <= 0:
		queue_free()


func _on_hitbox_area_entered(body) -> void:
	if body.is_in_group("bullet"):
		if body.has_method("get_damage"):
			take_damage(body.get_damage())
		body.queue_free()# Replace with function body.
