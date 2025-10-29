extends Area2D

signal picked_up
@export var weapon_name = "Tirachinas"
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.5   # segundos entre disparos
@export var range: float = 400       # rango para buscar enemigos

var player = null
var can_shoot = false
var shoot_timer = 0.0

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	if can_shoot and player:
		shoot_timer -= delta
		if shoot_timer <= 0:
			var target = get_nearest_enemy()
			if target:
				look_at(target.global_position)
				shoot(target)
				shoot_timer = fire_rate

func _on_body_entered(body):
	if body.name == "Max" or body.is_in_group("player"):
		player = body
		body.pickup_weapon(weapon_name)
		can_shoot = true
		get_parent().call_deferred("queue_free") # desaparece el arma del suelo
		

func get_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest = null
	var min_distance = range

	for e in enemies:
		if not e or not e.is_inside_tree():
			continue
		var dist = global_position.distance_to(e.global_position)
		if dist < min_distance:
			min_distance = dist
			nearest = e

	return nearest

func shoot(target):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.look_at(target.global_position)
	bullet.direction = (target.global_position - global_position).normalized()
	get_tree().current_scene.add_child(bullet)
