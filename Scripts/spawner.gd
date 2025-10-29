extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 2.0     # segundos entre spawns
@export var spawn_radius: float = 600       # distancia máxima del jugador
@export var max_enemies: int = 10           # cantidad máxima al mismo tiempo
@export var spawn_area: Rect2 = Rect2(Vector2(-1000, -500), Vector2(2000, 1000))
var spawn_timer = 0.0
var player: Node2D

func _ready():
	# Encuentra al jugador (ajusta el nombre si tu nodo se llama distinto)
	player = get_tree().get_root().get_node("Ruinas de acero/max")

func _process(delta):
	spawn_timer += delta

	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_enemy()

func spawn_enemy():
	if not player:
		return

	var current_enemies = get_tree().get_nodes_in_group("enemy").size()
	if current_enemies >= max_enemies:
		return

	var enemy = enemy_scene.instantiate()
	var pos = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)
	enemy.global_position = pos
	get_tree().current_scene.add_child(enemy)
	
	

	
