extends Node2D

##################################################
enum PlanetType{
	MOON,	#달
	MERCURY,	# 수성
	MARS,	# 화성
	VENUS	# 금성
}
# 낙하 되는 행성들의 타입 열거형 정의
# 금성 보다 큰 행성들은 합체해야만 볼 수 있음

@onready var moon: PackedScene = \
	preload("res://scenes/the_solar_system/01_moon/01_moon.tscn")
@onready var mercury: PackedScene = \
	preload("res://scenes/the_solar_system/02_mercury/02_mercury.tscn")
@onready var mars: PackedScene = \
	preload("res://scenes/the_solar_system/03_mars/03_mars.tscn")
@onready var venus: PackedScene = \
	preload("res://scenes/the_solar_system/04_venus/04_venus.tscn")

@onready var moon_texture: Texture = \
	preload("res://scenes/the_solar_system/01_moon/01_moon.png")
@onready var mercury_texture: Texture = \
	preload("res://scenes/the_solar_system/02_mercury/02_mercury.png")
@onready var mars_texture: Texture = \
	preload("res://scenes/the_solar_system/03_mars/03_mars.png")
@onready var venus_texture: Texture = \
	preload("res://scenes/the_solar_system/04_venus/04_venus.png")
# 각 행성의 씬과 텍스처를 미리 로드

@onready var spawn_timer: Timer = $Timer
# 컨트롤 되는 상단의 행성 소환 타이머
@onready var next_planet_sprite: Sprite2D = $NextPlanetSprite
# 다음 행성 미리보기 스프라이트

var controlled_planet:Node2D
# 컨트롤 되는 상단의 행성
var next_planet: PlanetType
# 다음 나올 행성 종류
var in_control: bool = true
# 행성이 상단에서 컨트롤 되고 있는지 여부
# 필요에 따라 좌우 움직임 제한을 주기 위함
var init_position: Vector2 = Vector2(320, 71)
# 컨트롤 되는 행성 생성 위치
var movement_speed: float = 100.0
# 컨트롤 되는 행성 좌우 이동 속도

##################################################
func _ready() -> void:
	init_planet()
	# 컨트롤 중인 행성과 다음 행성 초기화 설정
	
	spawn_timer.wait_time = 0.5
	spawn_timer.one_shot = true
	spawn_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	# 타이머 설정 및 _on_timer_timeout 함수와 연결

##################################################
func _physics_process(delta: float) -> void:
	if not is_instance_valid(controlled_planet):
		return
	# 혹시 모를 null 오류 방지
		
	if GameManager.get_game_over():
		if Input.is_action_just_pressed("ui_accept"):
			reset_game()
	# 게임 오버일 때 게임 초기화
	else:
		if Input.is_action_just_pressed("ui_accept"):
			controlled_planet.gravity_scale = 1
			# 게임 오버가 아닐 때 컨트롤 되는 행성에 중력 적용
			spawn_timer.start()
			# 타이머 시작
			in_control = false
			# 좌우 움직임 제한
	
	if in_control:
		controlled_planet.gravity_scale = 0
		# 타이머 종료 후 컨트롤 되는 행성을 움직일 때는 다시 중력을 제거
		
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left") and in_control:
		velocity.x -= movement_speed
		controlled_planet.linear_velocity = velocity
	# 좌로 이동
	elif Input.is_action_pressed("ui_right") and in_control:
		velocity.x += movement_speed
		controlled_planet.linear_velocity = velocity
	# 우로 이동
	elif in_control:
		velocity = Vector2.ZERO
		controlled_planet.linear_velocity = velocity
	# 가만 있을 때는 velocity 값을 제거하여 멈추도록 함

##################################################
func init_planet() -> void:
	controlled_planet = moon.instantiate()
	add_child(controlled_planet)
	controlled_planet.position = init_position
	# 컨트롤 중인 행성을 달로 설정
	
	next_planet = PlanetType.MOON
	next_planet_sprite.texture = moon_texture
	# 다음 미리보기 행성을 달로 설정

##################################################
func _on_timer_timeout() -> void:
	if is_instance_valid(controlled_planet):
		controlled_planet.add_to_group("FallenPlanet")
	# 타이머 종료 후 유효한 노드에 한하여 FallenPlanet 그룹에 추가
		
	var planet_type: PlanetType = next_planet
	match planet_type:
		PlanetType.MOON:
			controlled_planet = moon.instantiate()
		PlanetType.MERCURY:
			controlled_planet = mercury.instantiate()
		PlanetType.MARS:
			controlled_planet = mars.instantiate()
		PlanetType.VENUS:
			controlled_planet = venus.instantiate()
	# 다음 행성을 컨트롤 되는 행성에 설정
			
	next_planet =  randi_range(0, PlanetType.VENUS)
	match next_planet:
		PlanetType.MOON:
			next_planet_sprite.texture = moon_texture
		PlanetType.MERCURY:
			next_planet_sprite.texture = mercury_texture
		PlanetType.MARS:
			next_planet_sprite.texture = mars_texture
		PlanetType.VENUS:
			next_planet_sprite.texture = venus_texture
	# 다음 행성은 임의의 값으로 설정 및 텍스처 추가
		
	add_child(controlled_planet)
	controlled_planet.position = init_position
	in_control = true
	# 새로운 행성 노드 추가 및 초기화 설정

##################################################
func reset_game()-> void:
	if is_instance_valid(controlled_planet):
		remove_child(controlled_planet)
		controlled_planet.queue_free()
	# 현재 컨트롤 중인 행성이 존재하는 경우 제거
	
	var fallen_planets = get_tree().get_nodes_in_group("FallenPlanet")
	for planet in fallen_planets:
		if is_instance_valid(planet):
			remove_child(planet)
			planet.queue_free()
	# FallenPlanet 그룹의 모든 객체 제거
			
	init_planet()
	# 컨트롤 중인 행성과 다음 행성 초기화 설정
	
	GameManager.set_game_over(false)
	GameManager.set_score(0)
	in_control = true
	# 게임 상태 및 점수 초기화
