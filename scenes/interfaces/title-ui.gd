class_name TitleUI
extends Node

signal start_game

var rng = RandomNumberGenerator.new()

@onready var title_back1 = $MarginContainer/VBoxContainer/Title/TitleBackLabel
@onready var title_back2 = $MarginContainer/VBoxContainer/Title/TitleBackLabel2
@onready var title_back3 = $MarginContainer/VBoxContainer/Title/TitleBackLabel3

@onready var go_button = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GoButton
@onready var time_lasted = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/TimeLasted
@onready var time_lasted_status = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/TimeLasted/TimeLastedStatusLabel
@onready var score = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Score
@onready var score_status = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Score/Status

@onready var subtitles = $Subtitles
@onready var subtitle_timer = $Subtitles/Timer

var first_play: bool
var elapsed_time: Node
var subtitle_degrees: float = 300.0
var first_subtitle_rotation: bool = true

func initialize(first: bool, elapsed_time_node: Node):
	first_play = first
	elapsed_time = elapsed_time_node


func _ready():
	title_back1.visible_ratio = 0
	title_back3.visible_ratio = 0

	if not first_play:
		go_button.text = "Try Again"
		time_lasted.visible = true
		time_lasted_status.visible = true
		score.visible = true

		var seconds = fmod(elapsed_time.elapsed, 60)
		var minutes = fmod(elapsed_time.elapsed, 3600) / 60
		time_lasted_status.text = "%02d : %02d" % [minutes, seconds]

		score_status.text = "%d" % Globals.score


func _process(delta):
	title_back1.visible_ratio += delta / 1.5
	title_back3.visible_ratio += delta / 1.5

	subtitles.rotation_degrees = lerp(subtitles.rotation_degrees, subtitle_degrees, delta * 3.0)
	if first_subtitle_rotation:
		first_subtitle_rotation = false
		subtitle_timer.wait_time = 6.0


func _on_go_button_pressed():
	emit_signal("start_game")


func _on_timer_timeout():
	subtitle_degrees += 60.0

	subtitles.material.set_shader_parameter("strength", rng.randf_range(0.5, 1.0))
	subtitles.material.set_shader_parameter("speed", rng.randf_range(0.5, 1.75))
	subtitles.material.set_shader_parameter("angle", rng.randf_range(0.0, 360.0))
