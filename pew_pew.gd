extends Area2D

var speed = 10
var type: Constants.PewPewType

func init(pew_pew_type: Constants.PewPewType):
	type = pew_pew_type
	scale = Vector2(0.08, 0.08)
	if type == Constants.PewPewType.LARGE:
		scale = Vector2(0.1, 0.16)

func _ready():
	$Timer.start()

func _physics_process(_delta):
	position += Vector2.UP.rotated(rotation) * speed

func _on_Bullet_body_entered(body):
	if body.is_in_group("baddies"):
		body.queue_free()
	queue_free()

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	print(body)

func _on_area_entered(area):
	if area.is_in_group("baddies"):
		area.queue_free()
	queue_free()
