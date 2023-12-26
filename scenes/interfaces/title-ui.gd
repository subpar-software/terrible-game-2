class_name TitleUI
extends Node

signal start_game

var rng = RandomNumberGenerator.new()

@onready var title_ui_root = $"."

@onready var title_back1 = $MarginContainer/VBoxContainer/Title/TitleBackLabel
@onready var title_back2 = $MarginContainer/VBoxContainer/Title/TitleBackLabel2
@onready var title_back3 = $MarginContainer/VBoxContainer/Title/TitleBackLabel3

@onready var go_button = $MarginContainer/VBoxContainer/MarginContainer/MenuButtons/GoButton
@onready var options_button = $MarginContainer/VBoxContainer/MarginContainer/MenuButtons/OptionsButton

@onready var subtitles = $Subtitles
@onready var subtitle_timer = $Subtitles/Timer

var first_play: bool
var is_showing_options: bool = false
var current_position_y: float = 0.0

var subtitle_degrees: float = 300.0
var first_subtitle_rotation: bool = true


func initialize(first: bool):
	first_play = first


func _ready():
	if OS.has_feature('web'):
		options_button.visible = false

	title_back1.visible_ratio = 0
	title_back3.visible_ratio = 0

	if not first_play:
		go_button.text = "Try Again"


func _process(delta):
	title_back1.visible_ratio += delta / 1.5
	title_back3.visible_ratio += delta / 1.5

	subtitles.rotation_degrees = lerp(subtitles.rotation_degrees, subtitle_degrees, delta * 3.0)
	if first_subtitle_rotation:
		first_subtitle_rotation = false
		subtitle_timer.wait_time = 6.0

	title_ui_root.position.y = lerp(title_ui_root.position.y, current_position_y, delta * 4)


func toggle_options_menu():
	is_showing_options = !is_showing_options
	current_position_y = -645.0 if is_showing_options else 0.0


func _on_go_button_pressed():
	print("WUT")
	emit_signal("start_game")


func _on_options_button_pressed():
	toggle_options_menu()


func _on_back_button_pressed():
	toggle_options_menu()


func _on_subtitle_timer_timeout():
	subtitle_degrees += 60.0

	subtitles.material.set_shader_parameter("strength", rng.randf_range(0.5, 1.0))
	subtitles.material.set_shader_parameter("speed", rng.randf_range(0.5, 1.75))
	subtitles.material.set_shader_parameter("angle", rng.randf_range(0.0, 360.0))

