extends Node2D

var game_state: Constants.GameState = Constants.GameState.START
var prev_game_state: Constants.GameState = Constants.GameState.START

var first_play = true

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

var rng = RandomNumberGenerator.new()

var dont_like_this_dude = preload("res://baddie.tscn")
var max_baddies = 100
var current_spawn_point = 0
var all_baddies = []

func _process(_delta):
	if (game_state != Constants.GameState.PLAY and Input.is_action_pressed("ui_accept")):
		game_state = Constants.GameState.PLAY

	if (game_state != prev_game_state):
		match game_state:
			Constants.GameState.PLAY:
				Globals.current_baddies = 0
				Globals.total_baddies = 0
				$MenuUI.visible = false
				$MenuUI/AudioStreamPlayer.stop()
				$PlayUI.visible = true
				$PlayUI/AudioStreamPlayer.play()
				spawn_rate_timer.start()
				spawn_move_timer.start()
				$ElapsedTime.start_timing()
				defender.visible = true
				if first_play:
					first_play = false
					$PlayUI/AnimationPlayer.play("help_fade")

			Constants.GameState.OVER:
				defender.reset()
				$ElapsedTime.stop_timing()
				$MenuUI.visible = true
				$MenuUI/VBoxContainer/Button.text = " Try Again"
				$MenuUI/TimeLastedTitleLabel.visible = true
				$MenuUI/TimeLastedStatusLabel.visible = true
				$MenuUI/BaddiesSpawnedTitleLabel.visible = true
				$MenuUI/BaddiesSpawnedLabel.visible = true
				$MenuUI/TimeLastedStatusLabel.text = $ElapsedTime.str_elapsed
				$MenuUI/BaddiesSpawnedLabel.text = str(Globals.total_baddies)
				$MenuUI/AudioStreamPlayer.play()
				$PlayUI.visible = false
				$PlayUI/AudioStreamPlayer.stop()
				defender.visible = false
				spawn_rate_timer.stop()
				spawn_move_timer.stop()
				for baddie in get_tree().get_nodes_in_group("baddies"):
					baddie.queue_free()

	prev_game_state = game_state
	$PlayUI/BaddiesCountLabel.text = "Baddies: " +  str(Globals.total_baddies)

	# Increase spawn rate with time
	if $ElapsedTime.elapsed > 0.0:
		spawn_rate_timer.wait_time = 1.5
	if $ElapsedTime.elapsed > 15.0:
		spawn_rate_timer.wait_time = 1.0
	if $ElapsedTime.elapsed > 30.0:
		spawn_rate_timer.wait_time = 0.75
	if $ElapsedTime.elapsed > 45.0:
		spawn_rate_timer.wait_time = 0.5
	if $ElapsedTime.elapsed > 60.0:
		spawn_rate_timer.wait_time = 0.25


func _on_spawn_rate_timeout():
	if (Globals.current_baddies < max_baddies):
		var varaince = 100
		Globals.current_baddies += 1
		Globals.total_baddies += 1
		var baddie = dont_like_this_dude.instantiate()
		baddie.set_elapsed_time($ElapsedTime.elapsed)
		baddie.global_position = spawn_points[current_spawn_point].global_position + Vector2(rng.randf_range(-varaince , varaince), rng.randf_range(-varaince , varaince))
		add_child(baddie)


func _on_spawn_move_timeout():
	current_spawn_point = rng.randi_range(0 , 11)


func _on_button_pressed():
	game_state = Constants.GameState.PLAY


func _on_defender_dead():
	game_state = Constants.GameState.OVER


func _on_defender_action_surge_begin():
	$Camera2D.shake = true


func _on_defender_action_surge_end():
	$Camera2D.shake = false
