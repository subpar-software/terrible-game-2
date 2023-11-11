extends Area2D

@onready var attack_this = get_tree().get_nodes_in_group("IDunno")[0]

var rng = RandomNumberGenerator.new()

func _ready():
	$Sprite2D.material.set_shader_parameter("strength", rng.randf_range(0.4, 0.9))
	$Sprite2D.material.set_shader_parameter("angle", rng.randf_range(0.0, 360.0))

	var size = rng.randf_range(0.2, 0.55)
	scale = Vector2(size, size)

func _process(delta):
	position = position.lerp(attack_this.position, delta * 0.4) # slows down as approaches center


func _on_tree_exiting():
	Globals.current_baddies -= 1
