class_name Defender
extends Node2D

signal dead
signal surge_begin
signal surge_end

@export var start_health = 2
@export var hand_rotate_ratio = 6.0
@export var minute_hand_rotation_speed = 0.10

var rng = RandomNumberGenerator.new()

var pew_pew = preload("res://scenes/pewpew/pew_pew.tscn")

var plugin = preload("res://sounds/Plug-in.wav")
var plugout = preload("res://sounds/Plug-out.wav")
var hurt_sounds = [
	preload("res://sounds/Painsounds v2 - Track 1 - Arrrch.ogg"),
	preload("res://sounds/Painsounds v2 - Track 2 - Hurgh.ogg"),
	preload("res://sounds/Painsounds v2 - Track 3 - Huuurh.ogg"),
	preload("res://sounds/Painsounds v2 - Track 4 - Arrggh .ogg"),
	preload("res://sounds/Painsounds v2 - Track 5 - Urggh.ogg"),
	preload("res://sounds/Painsounds v2 - Track 6 - hyyrdhh.ogg")]

@onready var hour_hand = $HourHand
@onready var minute_hand = $MinuteHand
@onready var second_hand = $SecondHand
@onready var hour_fire_timer = $HourHand/FireRate
@onready var minute_fire_timer = $MinuteHand/FireRate

var curr_health = start_health
var is_surging = false
var hour_count = 0
var hour_can_fire = true
var minute_count = 0
var minute_can_fire = true

var surge_time: float = 0.0
var surge_time_remaining: float = 0.0

func _init():
	position = Vector2(1152 / 2.0, 648 / 2.0)
	curr_health = start_health


func _ready():
	$SecondHand.visible = false
	$SecondHand/CollisionShape2D.disabled = true


func _physics_process(_delta):

	if visible and Input.is_action_pressed("ui_right"):
		hour_hand.rotate(minute_hand_rotation_speed / hand_rotate_ratio)
		minute_hand.rotate(minute_hand_rotation_speed)
		second_hand.rotate(minute_hand_rotation_speed * 6)

	if visible and Input.is_action_pressed("ui_left"):
		hour_hand.rotate(-minute_hand_rotation_speed / hand_rotate_ratio)
		minute_hand.rotate(-minute_hand_rotation_speed)
		second_hand.rotate(-minute_hand_rotation_speed * 6)

	if hour_hand.rotation_degrees > 360.0:
		hour_hand.rotation_degrees -= 360.0
		hour_count += 1

	if hour_hand.rotation_degrees < -360.0:
		hour_hand.rotation_degrees += 360.0

	if minute_hand.rotation_degrees > 360.0:
		minute_hand.rotation_degrees -= 360.0
		minute_count += 1

	if minute_hand.rotation_degrees < -360.0:
		minute_hand.rotation_degrees += 360.0


	if Input.is_action_pressed("ui_accept") and minute_count >= 2:
		$AudioStreamPlayer.stream = plugin
		$AudioStreamPlayer.pitch_scale = 1.0
		$AudioStreamPlayer.play()
		is_surging = true
		convert_hours_to_health()
		hour_fire_timer.wait_time = 0.15
		hand_rotate_ratio = 3.0
		surge_time = minute_count / 2
		$ActionSurgeTimer.wait_time = minute_count / 2
		$ActionSurgeTimer.start()
		minute_count = 0
		$SecondHand.visible = true
		$SecondHand/CollisionShape2D.disabled = false
		$"../PlayUI/AudioStreamPlayer".pitch_scale = 1.5
		emit_signal("surge_begin")


	if (is_surging and minute_can_fire):
		minute_can_fire = false
		minute_fire_timer.start()
		var pew = pew_pew.instantiate()
		pew.init(Constants.PewPewType.SMALL, is_surging)
		add_child(pew)
		pew.global_position = $MinuteHand/WhereThePewHappens.global_position
		pew.rotation = $MinuteHand.rotation

	if (hour_can_fire):
		hour_can_fire = false
		hour_fire_timer.start()
		var bg_pew = pew_pew.instantiate()
		bg_pew.init(Constants.PewPewType.LARGE, is_surging)
		add_child(bg_pew)
		bg_pew.global_position = $HourHand/WhereThePewHappens.global_position
		bg_pew.rotation = $HourHand.rotation

	surge_time_remaining = $ActionSurgeTimer.time_left


func convert_hours_to_health():
	curr_health += hour_count
	hour_count = 0


func _on_hour_fire_rate_timeout():
	hour_can_fire = true


func _on_minute_fire_rate_timeout():
	minute_can_fire = true


func _on_area_2d_body_entered(body):
	if body.is_in_group("rings"):
		body.queue_free()
	curr_health -= 1
	$AnimationPlayer.play("hurt")
	$AudioStreamPlayer.stream = hurt_sounds[rng.randi_range(0, hurt_sounds.size() - 1)]
	$AudioStreamPlayer.pitch_scale = 1.8
	$AudioStreamPlayer.play()
	if (curr_health <= 0):
		emit_signal('dead')


func _on_action_surge_timer_timeout():
	is_surging = false
	$AudioStreamPlayer.stream = plugout
	$AudioStreamPlayer.pitch_scale = 1.0
	$AudioStreamPlayer.play()
	hour_fire_timer.wait_time = 0.25
	hand_rotate_ratio = 6.0
	$SecondHand.visible = false
	$SecondHand/CollisionShape2D.disabled = true
	$"../PlayUI/AudioStreamPlayer".pitch_scale = 1.0
	$ActionSurgeTimer.stop()
	emit_signal("surge_end")
