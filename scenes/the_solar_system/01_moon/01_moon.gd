extends RigidBody2D

##################################################
const MERCURY: PackedScene = \
	preload("res://scenes/the_solar_system/02_mercury/02_mercury.tscn")
# 달 다음은 수성이기 때문에 수성을 미리 로드

##################################################
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	# body_entered 신호를 _on_body_entered에 연결

##################################################
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Moon") and not body.is_in_group("Processed"):
		add_to_group("Processed")
		body.add_to_group("Processed")
		# 충돌을 한 번만 수행하기 위해서 Processed 그룹인지 확인 후 추가
		call_deferred("grow_planet", body)
		# 물리적 단계에서 grow_planet 함수가 실행되면 queue_free를 하기 때문에
		# 오류 발생 가능. 그래서 call_deferred로 다음 프레임으로 지연 호츌

##################################################
func grow_planet(body: Node) -> void:
	var new_mercury: Node2D = MERCURY.instantiate() as Node2D
	# 새로운 수성 노드 인스턴스 생성
	new_mercury.global_position = \
		GameManager.get_center_vector(global_position, body.global_position)
		# 현재 객체와 충돌 객체의 중심점을 구하여 new_mercury 좌표로 설정
	get_parent().add_child(new_mercury)
	# new_mercury를 부모 노드에 추가
	new_mercury.add_to_group("FallenPlanet")
	# new_mercury를 FallenPlanet 그룹에 추가
	
	GameManager.set_score(GameManager.get_score() + 3)
	GameManager.play_planet_grow_sound()
	# 게임 점수 업데이트 및 합체 소리 재생
	
	body.queue_free()
	queue_free()
	# 현재 객체와 충돌 객체를 메모리에서 해제
