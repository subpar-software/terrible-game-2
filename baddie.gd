extends RigidBody2D

@onready var attack_this = get_tree().get_first_node_in_group("defender")
@onready var destroy_timer = $DestroyTimer

var rng = RandomNumberGenerator.new()

var speed = 200
var speed_bonus = 1.0

func _ready():
	var size = rng.randf_range(0.2, 0.55)
	$Sprite2D.scale = Vector2(size, size)
	$Sprite2D.modulate = Color.from_hsv((randi() % 12) / 12.0, 1, 1)
	$CollisionShape2D.scale = Vector2(size, size)

	look_at(attack_this.global_position)
	apply_central_impulse(Vector2(cos(rotation), sin(rotation)) * speed * speed_bonus)


func set_elapsed_time(elapsed: float):
	if elapsed / 100 > speed_bonus:
		speed_bonus = elapsed / 100


func _on_tree_exiting():
	Globals.current_baddies -= 1


func _on_destroy_timer_timeout():
	queue_free()
