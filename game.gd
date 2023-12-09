extends Node2D

var game_state: Constants.GameState = Constants.GameState.START
var prev_game_state: Constants.GameState = Constants.GameState.START

@onready var defender = $Defender

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
@onready var spawn_rate_timer: Timer = $Timers/SpawnRate
@onready var spawn_move_timer: Timer = $Timers/SpawnMove

@onready var convert_button: Button = $PlayUI/ConvertButton

var rng = RandomNumberGenerator.new()

var dont_like_this_dude = preload("res://baddie.tscn")
var max_baddies = 15
var current_spawn_point = 0
var all_baddies = []

func _ready():
	Globals.current_baddies = 0

func _process(_delta):
	if (game_state != prev_game_state):
		match game_state:
			Constants.GameState.PLAY:
				$MenuUI.visible = false
				$PlayUI.visible = true
				defender.reset()
				spawn_rate_timer.start()
				spawn_move_timer.start()

			Constants.GameState.OVER:
				$MenuUI.visible = true
				$MenuUI/VBoxContainer/Button.text = "Try Again"
				$PlayUI.visible = false
				defender.visible = false
				spawn_rate_timer.stop()
				spawn_move_timer.stop()
				for baddie in get_tree().get_nodes_in_group("baddies"):
					baddie.queue_free()

	convert_button.disabled = false
	if defender.hour_count == 0:
		convert_button.disabled = true
	
	prev_game_state = game_state
	$PlayUI/BaddiesCountLabel.text = "Baddies Count: " +  str(Globals.current_baddies)


func _on_spawn_rate_timeout():
	if (Globals.current_baddies < max_baddies):
		Globals.current_baddies += 1
		var baddie = dont_like_this_dude.instantiate()
		baddie.global_position = spawn_points[current_spawn_point].global_position
		add_child(baddie)


func _on_spawn_move_timeout():
	current_spawn_point = rng.randi_range(0 , 11)


func _on_button_pressed():
	game_state = Constants.GameState.PLAY


func _on_defender_dead():
	game_state = Constants.GameState.OVER


func _on_convert_button_pressed():
	defender.convert_hours_to_health()
