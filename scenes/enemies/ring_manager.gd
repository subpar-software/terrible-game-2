extends Node

@export var varaince = 100

var rng = RandomNumberGenerator.new()

var ring_enemy = preload("res://scenes/enemies/ring.tscn")

@onready var spawn_points = $SpawnPoints
@onready var spawn_timer = $SpawnRate
@onready var spawn_point_move_timer = $SpawnPointMove
@onready var current_spawn_point = 0

var elaspsed_time: Node

func _process(_delta):
	if (is_inside_tree()):
		# Increase spawn rate with time
		if elaspsed_time.elapsed > 0.0:
			spawn_timer.wait_time = 1.5
		if elaspsed_time.elapsed > 15.0:
			spawn_timer.wait_time = 1.0
		if elaspsed_time.elapsed > 30.0:
			spawn_timer.wait_time = 0.75
		if elaspsed_time.elapsed > 45.0:
			spawn_timer.wait_time = 0.5
		if elaspsed_time.elapsed > 60.0:
			spawn_timer.wait_time = 0.25


func start(elaspsed_time_node: Node):
	elaspsed_time = elaspsed_time_node
	Globals.total_rings = 0
	Globals.current_rings = 0
	spawn_timer.start()
	spawn_point_move_timer.start()


func _on_spawn_rate_timeout():
	var current_spawn_position = spawn_points.get_child(current_spawn_point).global_position
	var variance_vector = Vector2(
		rng.randf_range(-varaince , varaince),
		rng.randf_range(-varaince , varaince))

	Globals.current_rings += 1
	Globals.total_rings += 1
	Globals.enemies_spawned += 1
	var ring = ring_enemy.instantiate()
	ring.set_elapsed_time(elaspsed_time.elapsed)
	ring.global_position = current_spawn_position + variance_vector
	add_child(ring)


func _on_spawn_point_move_timeout():
	current_spawn_point = rng.randi_range(0 , spawn_points.get_child_count() - 1)
