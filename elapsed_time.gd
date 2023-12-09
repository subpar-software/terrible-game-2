extends Node

var time_start = 0
var time_now = 0
var str_elapsed

var timing = false


func _process(delta):
	if (timing):
		time_now = Time.get_unix_time_from_system()
		var elapsed = time_now - time_start
		var seconds = fmod(elapsed,60)
		var minutes = fmod(elapsed, 3600) / 60
		str_elapsed = "%02d : %02d" % [minutes, seconds]
		$"../PlayUI/TimerLabel".text = "elapsed : " + str_elapsed


func start_timing():
	time_start = Time.get_unix_time_from_system()
	timing = true


func stop_timing():
	timing = false
