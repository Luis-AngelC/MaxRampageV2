extends CharacterBody2D

# STATS DE MAX
@export var Max_health: int = 3
var Current_health: int = Max_health
@export var Current_xp: int = 0
var XPtoNextlv: int = 100
@export var Level: int = 1

# ARMA
var has_weapon = false
var current_weapon = ""
var can_shoot = true
@export var shoot_cooldown = 0.3
@export var detection_range = 300.0
# Referencia a la escena de la bala
@export var bullet_scene: PackedScene

# MOVIMIENTO DE MAX
@export var MAX_SPEED: float = 90.0
@export var ACCELERATION: float = 2900.0
@export var FRICTION: float = 1000.0

# Variables para movimiento con mouse
var is_mouse_pressed: bool = false
var TARGET_THRESHOLD: float = 10.0  # Distancia mínima para evitar temblores

# Referencia al AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	add_to_group("player")
	pass


func recibir_dano(daño):
	Current_health = max(Current_health - daño, 0)
	print("Has recibido daño!!")
	if Current_health == 0:
		print("Game Over")

func curar():
	if Current_health < Max_health:
		Current_health = min(Current_health + 1, Max_health)

func _input(event):
	# Detectar cuando se presiona o suelta el click izquierdo
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_mouse_pressed = event.pressed

func _physics_process(delta):
	
	# Obtener dirección de input del teclado (WASD/Flechas)
	var input_direction = get_input_direction()
	
	# Si hay input del teclado, tiene prioridad sobre el mouse
	if input_direction.length() > 0:
		is_mouse_pressed = false  # Cancelar movimiento del mouse
		var move_direction = input_direction.normalized()
		apply_movement(move_direction, delta)
	elif is_mouse_pressed:
		# Movimiento continuo hacia la posición del mouse mientras está presionado
		var mouse_pos = get_global_mouse_position()
		var direction_to_mouse = (mouse_pos - global_position).normalized()
		var distance_to_mouse = global_position.distance_to(mouse_pos)

		
		# Solo moverse si estamos a cierta distancia del mouse
		if distance_to_mouse > TARGET_THRESHOLD:
			apply_movement(direction_to_mouse, delta)
		else:
			# Si está muy cerca, aplicar fricción para evitar temblores
			apply_friction(delta)
	else:
		# Aplicar fricción cuando no hay input
		apply_friction(delta)
	
	move_and_slide()
	
	# Actualizar animación basada en la velocidad real
	update_animation()
	if has_weapon and can_shoot:
		var nearest_enemy = get_nearest_enemy()
		if nearest_enemy:
			shoot(nearest_enemy)

func pickup_weapon(weapon_name: String):
	has_weapon = true
	current_weapon = weapon_name
	print("¡Arma recogida: ", weapon_name, "!")
	
func get_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest_enemy = null
	var shortest_distance = detection_range
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_enemy = enemy
	
	return nearest_enemy

func shoot(target):
	if bullet_scene == null:
		print("Error: No se ha asignado la escena de bala")
		return
	
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	
	# Dirección hacia el enemigo
	var direction = (target.global_position - global_position).normalized()
	bullet.direction = direction
	
	# Añadir la bala a la escena
	get_parent().add_child(bullet)
	
	# Cooldown de disparo
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true



func get_input_direction() -> Vector2:
	# Obtener dirección de las teclas
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	return direction

func apply_movement(direction: Vector2, delta: float):
	# Acelerar hacia la velocidad máxima
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func apply_friction(delta: float):
	# Desacelerar suavemente
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# Evitar que queden valores residuales muy pequeños
	if velocity.length() < 1.0:
		velocity = Vector2.ZERO

func update_animation():
	# Verificar que animated_sprite existe
	if not animated_sprite:
		return
	
	var speed = velocity.length()

	# Si la velocidad es muy baja o cero, está quieto (idle)
	if speed <= 1.0:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
	else:
		# Está en movimiento (run)
		if animated_sprite.animation != "run":
			animated_sprite.play("run")
		
		# Voltear el sprite según la dirección de la velocidad
		if velocity.x > 0:
			animated_sprite.flip_h = false  # Mirando a la derecha
		elif velocity.x < 0:
			animated_sprite.flip_h = true   # Mirando a la izquierda
