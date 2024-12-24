extends RigidBody2D

##################################################
const NEPTUNE = \
	preload("res://scenes/the_solar_system/06_neptune/06_neptune.tscn")

##################################################
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

##################################################
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Earth") and not body.is_in_group("Processed"):
		add_to_group("Processed")
		body.add_to_group("Processed")
		call_deferred("grow_planet", body)

##################################################
func grow_planet(body: Node) -> void:
	var new_neptune = NEPTUNE.instantiate()
	new_neptune.global_position = \
		get_center_vector(global_position, body.global_position)
	get_parent().add_child(new_neptune)
	new_neptune.add_to_group("FallenPlanet")
	
	GameManager.set_score(GameManager.get_score() + 21)
	GameManager.play_planet_grow_sound()
	
	body.queue_free()
	queue_free()

##################################################
func get_center_vector(vector1: Vector2, vector2: Vector2) -> Vector2:
	var center_vector = (vector1 + vector2) / 2
	return center_vector
