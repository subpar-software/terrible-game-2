extends Area2D

var speed = 10
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
			
	$DestroyTimer.start()
	if (explode):
		$ExplodeTimer.start()


func _physics_process(_delta):
	var this_speed = speed if explode else speed * 4
	position += Vector2.UP.rotated(rotation) * this_speed


func _on_body_entered(body):
	if body.is_in_group("baddies"):
		body.queue_free()
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
