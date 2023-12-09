extends RigidBody2D

@onready var attack_this = get_tree().get_first_node_in_group("defender")
@onready var destroy_timer = $DestroyTimer

var rng = RandomNumberGenerator.new()

func _ready():
	$Sprite2D.material.set_shader_parameter("strength", rng.randf_range(0.4, 0.9))
	$Sprite2D.material.set_shader_parameter("angle", rng.randf_range(0.0, 360.0))

	var size = rng.randf_range(0.2, 0.55)
	$Sprite2D.scale = Vector2(size, size)
	$CollisionShape2D.scale = Vector2(size, size)

	look_at(attack_this.global_position)
	apply_central_impulse(Vector2(cos(rotation), sin(rotation)) * 200)


func _on_tree_exiting():
	Globals.current_baddies -= 1


func _on_destroy_timer_timeout():
	queue_free()
