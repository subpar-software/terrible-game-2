class_name PlayUI
extends Node2D

@onready var hour_status: Label = $HoursStatus
@onready var hour_animation: AnimationPlayer = $HourAnimation
@onready var minute_status: Label = $MinutesStatus
@onready var minute_animation: AnimationPlayer = $MinuteAnimation
@onready var score_status: RichTextLabel = $ScoreStatus
@onready var time_played_status: Label = $TimePlayedStatus
@onready var player_health: ProgressBar = $Container/Top/Middle/Health
@onready var surge_time: ProgressBar = $Container/Top/Middle/Surge

var elapsed_time: Node
var defender: Defender

# For comparison to animate increases
var current_hour_count: int = 0
var current_minute_count: int = 0

var score: int = 0


func initialize(elapsed_time_node: Node, defender_node: Defender):
	elapsed_time = elapsed_time_node
	defender = defender_node


func _process(_delta):
	update_clock()
	update_hour()
	update_minute()
	update_health_bar()
	update_surge_bar()
	update_score()


func update_clock():
	var seconds = fmod(elapsed_time.elapsed, 60)
	var minutes = fmod(elapsed_time.elapsed, 3600) / 60
	time_played_status.text = "%02d : %02d" % [minutes, seconds]


func update_hour():
	if current_hour_count < defender.hour_count:
		hour_animation.play('increase_hour_count')
	current_hour_count = defender.hour_count
	hour_status.text = "%d" % defender.hour_count


func update_minute():
	if current_minute_count < defender.minute_count:
		minute_animation.play('increase_minute_count')
	current_minute_count = defender.minute_count
	minute_status.text = "%d" % current_minute_count


func update_health_bar():
	player_health.value = defender.curr_health


func update_surge_bar():
	surge_time.visible = defender.is_surging
	surge_time.max_value = defender.surge_time
	surge_time.value = defender.surge_time_remaining


func update_score():
	score_status.text = "[right]%d[/right]" % Globals.score
