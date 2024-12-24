extends Node

##################################################
var score = 0
var game_over = false
var planet_grow_sound = preload("res://sounds/planet_grow_sound.wav")
var sound = AudioStreamPlayer2D.new()

##################################################
func _ready() -> void:
	sound.stream = planet_grow_sound
	add_child(sound)

##################################################
func get_game_over() -> bool:
	return game_over

##################################################
func set_game_over(value:bool) -> void:
	game_over = value

##################################################
func get_score() -> int:
	return score

##################################################
func set_score(value:int) -> void:
	score = value

##################################################
func play_planet_grow_sound() -> void:
	sound.play()
