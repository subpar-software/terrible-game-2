class_name HelpUI
extends Control

@export var show_surge_available_at_minute = 10

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

	show_surge_available.visible = defender.minute_count >= show_surge_available_at_minute
