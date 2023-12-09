extends Camera2D

var rand = RandomNumberGenerator.new()

var shake_strength: float = 2.0
var shake = false

func _process(delta):
	if shake:
		offset += Vector2(
			rand.randf_range(-shake_strength, shake_strength), 
			rand.randf_range(-shake_strength, shake_strength))

	else:
		offset = Vector2(
			lerpf(offset.x, 576.0, delta * 4),
			lerpf(offset.y, 324.0, delta * 4)
		)

