class_name PlayUI
extends Node2D

var health_icon = preload("res://scenes/interfaces/health_icon.tscn")
var surge_icon = preload("res://scenes/interfaces/surge_icon.tscn")

@onready var elapsed_time_status: Label = $ElapsedTimeStatus
@onready var health_bar: ProgressBar = $Container/Top/Middle/Health
@onready var health_icon_location: Node2D = $HealthIconsLocation
@onready var surge_time: ProgressBar = $Container/Top/Middle/Surge
@onready var surge_icon_location: Node2D = $SurgeIconsLocation
@onready var surge_min_indicator: Panel = $SurgeMinIndicator

var elapsed_time: Node
var defender: Defender

var health_icons: int = 0
var surge_icon_count: int = 0

func initialize(elapsed_time_node: Node, defender_node: Defender):
	elapsed_time = elapsed_time_node
	defender = defender_node


func _process(_delta):
	update_elapsed_time()
	update_health_bar()
	update_health_icons()
	update_surge_bar()
	update_surge_icons()


func update_elapsed_time():
	var seconds = fmod(elapsed_time.elapsed, 60)
	var minutes = fmod(elapsed_time.elapsed, 3600) / 60
	elapsed_time_status.text = "%02d : %02d" % [minutes, seconds]


func update_health_bar():
	health_bar.value = defender.curr_health


func update_health_icons():
	if health_icons != defender.hour_count:
		health_icons = defender.hour_count

		for each in health_icon_location.get_children():
			each.queue_free()

		for i in range(health_icons):
			var hi = health_icon.instantiate()
			hi.position.x = i * 30
			health_icon_location.add_child(hi)


func update_surge_bar():
	surge_time.max_value = defender.surge_time
	surge_time.value = defender.surge_time_remaining


func update_surge_icons():
	if surge_icon_count != defender.minute_count:
		surge_icon_count = defender.minute_count
		surge_min_indicator.visible	= surge_icon_count > 0

		for each in surge_icon_location.get_children():
			each.queue_free()

		for i in range(surge_icon_count):
			var si = surge_icon.instantiate()
			si.position.x = i * -30
			surge_icon_location.add_child(si)
