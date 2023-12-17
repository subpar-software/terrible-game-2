class_name PlayUI
extends Node2D

@export var show_surge_available_at_minute = 10

@onready var hour_count_label = $HourCountLabel
@onready var minute_count_label = $MinuteCountLabel
@onready var defender_health_label = $DefenderHealthLabel
@onready var ring_count_label = $RingsCountLabel
@onready var elapsed_time_label = $ElapsedTimeLabel
@onready var show_surge_available = $SurgeAvailableLabel
@onready var animation_player = $AnimationPlayer

var first_play: bool
var elapsed_time: Node
var defender: Defender


func initialize(first: bool, elapsed_time_node: Node, defender_node: Defender):
	elapsed_time = elapsed_time_node
	defender = defender_node
	first_play = first


func _process(_delta):
	if first_play:
		first_play = false
		animation_player.play("help_fade")

	var seconds = fmod(elapsed_time.elapsed, 60)
	var minutes = fmod(elapsed_time.elapsed, 3600) / 60
	elapsed_time_label.text = "Elapsed: %02d : %02d" % [minutes, seconds]

	hour_count_label.text = "Hour: %d" % defender.hour_count
	minute_count_label.text = "Minute: %d" % defender.minute_count
	defender_health_label.text = "Health: %d" % defender.curr_health

	show_surge_available.visible = defender.minute_count >= show_surge_available_at_minute
	
	ring_count_label.text = "Rings: %d" % Globals.total_rings
