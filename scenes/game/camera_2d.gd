extends Camera2D

var rand = RandomNumberGenerator.new()

@onready var game = $".."

var shake_strength: float = 2.0


func _process(delta):
	if game.is_surging:
		zoom = Vector2(lerpf(zoom.x, 0.95,delta * 2), lerpf(zoom.y, 0.95, delta * 2))
		offset += Vector2(
			rand.randf_range(-shake_strength, shake_strength), 
			rand.randf_range(-shake_strength, shake_strength))

	else:
		zoom = Vector2(lerpf(zoom.x, 1.0, delta * 2), lerpf(zoom.y, 1.0, delta * 2))
		offset = Vector2(
			lerpf(offset.x, 0.0, delta * 4),
			lerpf(offset.y, 0.0, delta * 4))
