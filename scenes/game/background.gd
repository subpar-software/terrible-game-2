extends ParallaxBackground

@onready var game = $".."

@onready var offset_wander_locations = $OffsetWanderLocations
@onready var offset_wander_location_count = offset_wander_locations.get_child_count()
@onready var wander_location = offset_wander_locations.get_child(randi_range(0, offset_wander_location_count - 1))

const SCROLL_SPEED_STANDARD = 100
var SCROLL_SPEED_FAST = 500

var scroll = 0


func _process(delta):
	scroll -= (SCROLL_SPEED_STANDARD if not game.is_surging else SCROLL_SPEED_FAST) * delta
	scroll_offset.x = scroll
	
	offset = Vector2(lerpf(offset.x, wander_location.position.x, delta / 10), lerpf(offset.y, wander_location.position.y, delta / 10))
	
	rotation += 0.001 if not game.is_surging else -0.002


func _on_offset_wander_timer_timeout():
	wander_location = offset_wander_locations.get_child(randi_range(0, offset_wander_location_count - 1))
