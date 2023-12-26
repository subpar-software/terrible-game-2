class_name HelpUI
extends Control

@export var show_surge_available_at_minute = 10

@onready var surge_icon_help = $SurgeIconHelp
@onready var health_icon_help = $HealthIconHelp
@onready var show_surge_available = $SurgeAvailableLabel

@onready var animation_player = $AnimationPlayer

var elapsed_time: Node
var defender: Defender

var initial_help_shown: bool = false
var health_icon_help_shown: bool = false
var surge_icon_help_shown: bool = false


func initialize(elapsed_time_node: Node, defender_node: Defender):
	elapsed_time = elapsed_time_node
	defender = defender_node


func _process(_delta):
	if not initial_help_shown:
		initial_help_shown = true
		animation_player.play("initial_help_fade")
		
	if not surge_icon_help_shown and defender.minute_count >= 2:
		surge_icon_help_shown = true
		animation_player.queue("surge_icon_help_fade")
	
	if not health_icon_help_shown and defender.hour_count >= 1:
		health_icon_help_shown = true
		animation_player.queue("health_icon_help_fade")

	show_surge_available.visible = defender.minute_count >= show_surge_available_at_minute
