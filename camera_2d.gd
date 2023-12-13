extends Camera2D

var rand = RandomNumberGenerator.new()

var shake_strength: float = 2.0
var shake = false

func _process(delta):
	if shake:
		zoom = Vector2(lerpf(zoom.x, 0.95,delta * 2), lerpf(zoom.y, 0.95, delta * 2))
		offset += Vector2(
			rand.randf_range(-shake_strength, shake_strength), 
			rand.randf_range(-shake_strength, shake_strength))

	else:
		zoom = Vector2(lerpf(zoom.x, 1.0, delta * 2), lerpf(zoom.y, 1.0, delta * 2))
		offset = Vector2(
			lerpf(offset.x, 576.0, delta * 4),
			lerpf(offset.y, 324.0, delta * 4)
		)

