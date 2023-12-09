extends Sprite2D

signal dead

@onready var hour_hand = $HourHand
@onready var minute_hand = $MinuteHand
@onready var second_hand = $SecondHand

@onready var hour_fire_timer = $HourHand/FireRate
@onready var minute_fire_timer = $MinuteHand/FireRate

@onready var hour_count_label = $"../PlayUI/HourCountLabel"
@onready var minute_count_label = $"../PlayUI/MinuteCountLabel"
@onready var health_label = $"../PlayUI/HealthLabel"

var max_health = 2
var curr_health = 0

var hour_can_fire = true
var minute_can_fire = true
var minute_has_fire = false

var hour_count = 0
var minute_count = 0

var current_speed = 0.10

var pew_pew = preload("res://pew_pew.tscn")


func _physics_process(_delta):

	if Input.is_action_pressed("ui_right"):
		hour_hand.rotate(current_speed / 6.0)
		minute_hand.rotate(current_speed)
		second_hand.rotate(current_speed * 6)
		
	if Input.is_action_pressed("ui_left"):
		hour_hand.rotate(-current_speed / 6.0)
		minute_hand.rotate(-current_speed)
		second_hand.rotate(-current_speed * 6)
	
	if hour_hand.rotation_degrees > 360.0:
		hour_hand.rotation_degrees -= 360.0
		hour_count += 1
	
	if hour_hand.rotation_degrees < 0.0:
		hour_hand.rotation_degrees += 360.0
		hour_count -= 1

	if minute_hand.rotation_degrees > 360.0:
		minute_hand.rotation_degrees -= 360.0
		minute_count += 1

	if minute_hand.rotation_degrees < 0.0:
		minute_hand.rotation_degrees += 360.0
		minute_count -= 1
	
	hour_count_label.text = "Hour: " + str(hour_count)
	minute_count_label.text = "Minute: " + str(minute_count)
	
	if Input.is_action_pressed("ui_accept"):
		if (minute_has_fire and minute_can_fire):
			minute_can_fire = false
			minute_fire_timer.start()
			var pew = pew_pew.instantiate()
			pew.init(Constants.PewPewType.SMALL)
			add_child(pew)
			pew.global_position = $MinuteHand/WhereThePewHappens.global_position
			pew.rotation = $MinuteHand.rotation

		if (hour_can_fire):
			hour_can_fire = false
			hour_fire_timer.start()
			var bg_pew = pew_pew.instantiate()
			bg_pew.init(Constants.PewPewType.LARGE)
			add_child(bg_pew)
			bg_pew.global_position = $HourHand/WhereThePewHappens.global_position
			bg_pew.rotation = $HourHand.rotation


func reset():
	visible = true
	hour_hand.rotation_degrees = 0
	minute_hand.rotation_degrees = 0
	curr_health = max_health
	health_label.text = "Health: " + str(curr_health)


func convert_hours_to_health():
	curr_health += hour_count
	hour_count = 0
	health_label.text = "Health: " + str(curr_health)

func _on_hour_fire_rate_timeout():
	hour_can_fire = true


func _on_minute_fire_rate_timeout():
	minute_can_fire = true


func _on_area_2d_body_entered(body):
	if body.is_in_group("baddies"):
		body.queue_free()
	curr_health -= 1
	health_label.text = "Health: " + str(curr_health)
	if (curr_health <= 0):
		emit_signal('dead')
