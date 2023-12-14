extends Area2D

signal baddie_killed

const SPEED_STANDARD = 6
const SPEED_EXPLODE = 15
var speed = SPEED_STANDARD
var type: Constants.PewPewType

var explode: bool = false

var pew_pew = preload("res://pew_pew.tscn")

func init(pew_pew_type: Constants.PewPewType, action_surge: bool):
	type = pew_pew_type
	explode = action_surge


func _ready():
	if not get_parent().is_in_group("pewpew"):
		scale = Vector2(0.08, 0.08)
		if type == Constants.PewPewType.LARGE:
			scale = Vector2(0.05, 0.08)
	else:
		speed = SPEED_EXPLODE

	$DestroyTimer.start()
	if (explode):
		$ExplodeTimer.start()


func _physics_process(_delta):
	position += Vector2.UP.rotated(rotation) * speed


func _on_body_entered(body):
	if body.is_in_group("baddies"):
		body.remove()
	queue_free()


func _on_destroy_timer_timeout():
	queue_free()


func _on_explode_timer_timeout():
	var degrees = 45.0
	for each in range(0, 7):
		var pew = pew_pew.instantiate()
		pew.init(type, false)
		pew.rotation = degrees * each
		add_child(pew)
