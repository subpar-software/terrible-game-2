extends Node

var time_start = 0
var time_now = 0
var elapsed = 0.0
var str_elapsed

var timing = false


func _process(_delta):
	if (timing):
		time_now = Time.get_unix_time_from_system()
		elapsed = time_now - time_start


func start_timing():
	elapsed = 0.0
	time_start = Time.get_unix_time_from_system()
	timing = true


func stop_timing():
	timing = false
