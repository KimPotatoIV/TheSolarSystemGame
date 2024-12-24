extends Area2D

##################################################
var game_over_sound = preload("res://sounds/game_over.wav")

##################################################
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

##################################################
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("FallenPlanet"):
		GameManager.set_game_over(true)
		
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = game_over_sound
		audio_player.volume_db = -20.0
		add_child(audio_player)
		
		if not audio_player.playing:
			audio_player.play()
