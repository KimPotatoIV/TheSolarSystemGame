extends RigidBody2D

##################################################
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

##################################################
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Jupiter") and not body.is_in_group("Processed"):
		add_to_group("Processed")
		body.add_to_group("Processed")
		call_deferred("grow_planet", body)

##################################################
func grow_planet(body: Node) -> void:	
	GameManager.set_score(GameManager.get_score() + 66)
	GameManager.play_planet_grow_sound()
	
	body.queue_free()
	queue_free()
