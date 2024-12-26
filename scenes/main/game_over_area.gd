extends Area2D

##################################################
var game_over_sound: AudioStream = preload("res://sounds/game_over.wav")
# 게임 오버 소리 미리 로드
var game_over_audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
# 게임 오버 소리 재생 플레이어

##################################################
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	# body_entered 신호를 _on_body_entered 함수에 연결
	
	game_over_audio_player.stream = game_over_sound
	game_over_audio_player.volume_db = -20.0
	add_child(game_over_audio_player)
	# 플레이어에 게임 오버 소리 stream 설정 후 볼륨 조절 및 노드 추가

##################################################
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("FallenPlanet"):
	# 충돌 객체가 FallenPlanet 그룹인지 확인 후
		GameManager.set_game_over(true)
		# 게임 오버 설정
		# 아직 떨어트리지 않은 행성과 충돌 하는 경우를 피하기 위함
		
		if not game_over_audio_player.playing:
			game_over_audio_player.play()
		# 게임 오버 소리가 재생 중이지 않을 때 재샐
