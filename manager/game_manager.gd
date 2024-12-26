extends Node

##################################################
var score: int = 0
# 게임 점수
var game_over: bool = false
# 게임 오버 여부
var planet_grow_sound: AudioStream = \
	preload("res://sounds/planet_grow_sound.wav")
# 합체 소리 미리 로드
var grow_audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
# 합체 소리 재생 플레이어

##################################################
func _ready() -> void:
	grow_audio_player.stream = planet_grow_sound
	add_child(grow_audio_player)
	# 플레이어에 합체 소리 stream 설정 후 노드 추가

##################################################
func get_game_over() -> bool:
	return game_over
	# 게임 오버 여부 반환

##################################################
func set_game_over(value:bool) -> void:
	game_over = value
	# 게임 오버 여부 설정

##################################################
func get_score() -> int:
	return score
	# 게임 점수 반환

##################################################
func set_score(value:int) -> void:
	score = value
	# 게임 점수 설정

##################################################
func play_planet_grow_sound() -> void:
	grow_audio_player.play()
	# 합체 소리 재생

##################################################
func get_center_vector(vector1: Vector2, vector2: Vector2) -> Vector2:
	var center_vector: Vector2 = (vector1 + vector2) / 2
	return center_vector
	# 각 벡터의 중심 벡터를 구하여 반환
