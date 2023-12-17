class_name TitleUI
extends Node2D

signal start_game

@onready var go_button = $VBoxContainer/GoButton
@onready var title_back = $TitleBackLabel
@onready var time_lasted_title = $TimeLastedTitleLabel
@onready var time_lasted_status = $TimeLastedStatusLabel
@onready var rings_spawned_title = $RingsSpawnedTitleLabel
@onready var rings_spawned_status = $RingsSpawnedLabel

var first_play: bool
var elapsed_time: Node


func initialize(first: bool, elapsed_time_node: Node):
	first_play = first
	elapsed_time = elapsed_time_node


func _ready():
	title_back.visible_ratio = 0
	if not first_play:
		go_button.text = "Try Again"
		time_lasted_title.visible = true
		time_lasted_status.visible = true
		rings_spawned_title.visible = true
		rings_spawned_status.visible = true

		var seconds = fmod(elapsed_time.elapsed, 60)
		var minutes = fmod(elapsed_time.elapsed, 3600) / 60
		time_lasted_status.text = "%02d : %02d" % [minutes, seconds]
#
		rings_spawned_status.text = str(Globals.total_rings)


func _process(delta):
	title_back.visible_ratio += delta


func _on_go_button_pressed():
	emit_signal("start_game")
