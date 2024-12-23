extends Camera2D

##################################################
var shake_duration = 5.0
var shake_magnitude = 10.0

var original_position
var shake_time = 0.0
var shaking = false

##################################################
func _ready() -> void:
	original_position = position

##################################################
func _process(delta: float) -> void:
	if shaking:
		shake_time += delta
		if shake_time < shake_duration:
			var offset = Vector2(randf_range(-shake_magnitude, -shake_magnitude), randf_range(-shake_magnitude, -shake_magnitude))
			position = original_position + offset
		else:
			position = original_position
			shaking = false

##################################################
func start_shaking() -> void:
	shake_time = 0.0
	shaking = true
