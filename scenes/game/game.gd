extends Node2D

var rng = RandomNumberGenerator.new()

var game_state: Constants.GameState = Constants.GameState.START
var prev_game_state: Constants.GameState = Constants.GameState.NONE

var first_play = true
var is_surging = false

var play_ui_scene = preload("res://scenes/interfaces/play_ui.tscn")
var play_ui: PlayUI

var title_ui_scene = preload("res://scenes/interfaces/title_ui.tscn")
var title_ui: TitleUI

var defender_scene = preload("res://scenes/defender/defender.tscn")
var defender: Node2D

var ring_manager_scene = preload("res://scenes/enemies/ring_manager.tscn")
var ring_manager

@onready var elapsed_time = $ElapsedTime
@onready var enemy_managers = $EnemyManagers

func _process(_delta):
	if (game_state != prev_game_state):
		match game_state:
			Constants.GameState.START:
				title_ui = title_ui_scene.instantiate()
				title_ui.initialize(first_play, elapsed_time)
				add_child(title_ui)
				title_ui.start_game.connect(func(): game_state = Constants.GameState.PLAY)
				
			Constants.GameState.PLAY:
				title_ui.queue_free()

				defender = defender_scene.instantiate()
				add_child(defender)
				defender.dead.connect(func(): game_state = Constants.GameState.OVER)
				defender.surge_begin.connect(func(): is_surging = true)
				defender.surge_end.connect(func(): is_surging = false)

				ring_manager = ring_manager_scene.instantiate()
				enemy_managers.add_child(ring_manager)
				ring_manager.start(elapsed_time)

				play_ui = play_ui_scene.instantiate()
				play_ui.initialize(first_play, elapsed_time, defender)
				add_child(play_ui)
				if first_play:
					first_play = false

				elapsed_time.start_timing()

			Constants.GameState.OVER:
				is_surging = false

				defender.queue_free()
				ring_manager.queue_free()
				play_ui.queue_free()
				
				title_ui = title_ui_scene.instantiate()
				title_ui.initialize(first_play, elapsed_time)
				add_child(title_ui)

				elapsed_time.stop_timing()

	prev_game_state = game_state
	if (game_state == Constants.GameState.NONE):
		game_state = Constants.GameState.START
	
	if (game_state != Constants.GameState.PLAY and Input.is_action_just_pressed("ui_accept")):
		game_state = Constants.GameState.PLAY
