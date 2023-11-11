extends Node2D


@onready var spawn_points = [
	$SpawnPoints/Point1,
	$SpawnPoints/Point2,
	$SpawnPoints/Point3,
	$SpawnPoints/Point4,
	$SpawnPoints/Point5,
	$SpawnPoints/Point6,
	$SpawnPoints/Point7,
	$SpawnPoints/Point8,
	$SpawnPoints/Point9,
	$SpawnPoints/Point10,
	$SpawnPoints/Point11,
	$SpawnPoints/Point12,
]
@onready var spawn_rate_timer = $Timers/SpawnRate
@onready var spawn_move_timer = $Timers/SpawnMove

var rng = RandomNumberGenerator.new()

var dont_like_this_dude = preload("res://dont_like_this_dude.tscn")
var max_baddies = 15
var current_spawn_point = 0

func _ready():
	Globals.current_baddies = 0

func _process(_delta):
	pass

func _on_spawn_rate_timeout():
	if (Globals.current_baddies < max_baddies):
		Globals.current_baddies += 1
		var baddie = dont_like_this_dude.instantiate()
		add_child(baddie)
		baddie.global_position = spawn_points[current_spawn_point].global_position


func _on_spawn_move_timeout():
	current_spawn_point = rng.randi_range(0 , 11)
