extends RigidBody2D

##################################################
const VENUS: PackedScene = \
	preload("res://scenes/the_solar_system/04_venus/04_venus.tscn")

##################################################
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

##################################################
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Mars") and not body.is_in_group("Processed"):
		add_to_group("Processed")
		body.add_to_group("Processed")
		call_deferred("grow_planet", body)

##################################################
func grow_planet(body: Node) -> void:
	var new_venus: Node2D = VENUS.instantiate()
	new_venus.global_position = \
		GameManager.get_center_vector(global_position, body.global_position)
	get_parent().add_child(new_venus)
	new_venus.add_to_group("FallenPlanet")
	
	GameManager.set_score(GameManager.get_score() + 10)
	GameManager.play_planet_grow_sound()
	
	body.queue_free()
	queue_free()
