extends Node2D

##################################################
enum PlanetType{
	MOON,
	MERCURY,
	MARS,
	VENUS
}

@onready var moon = preload("res://scenes/the_solar_system/01_moon/01_moon.tscn")
@onready var mercury = preload("res://scenes/the_solar_system/02_mercury/02_mercury.tscn")
@onready var mars = preload("res://scenes/the_solar_system/03_mars/03_mars.tscn")
@onready var venus = preload("res://scenes/the_solar_system/04_venus/04_venus.tscn")

@onready var moon_texture = preload("res://scenes/the_solar_system/01_moon/01_moon.png")
@onready var mercury_texture = preload("res://scenes/the_solar_system/02_mercury/02_mercury.png")
@onready var mars_texture = preload("res://scenes/the_solar_system/03_mars/03_mars.png")
@onready var venus_texture = preload("res://scenes/the_solar_system/04_venus/04_venus.png")

@onready var spawn_timer = $Timer
@onready var next_planet_sprite = $NextPlanetSprite

var controlled_planet
var next_planet
var in_control = true

var init_position = Vector2(320, 71)

##################################################
var movement_speed = 100.0

##################################################
func _ready() -> void:
	controlled_planet = moon.instantiate()
	add_child(controlled_planet)
	controlled_planet.position = init_position
	
	next_planet = randi_range(0, PlanetType.VENUS)
	next_planet_sprite.texture = moon_texture
	
	spawn_timer.wait_time = 0.5
	spawn_timer.one_shot = true
	spawn_timer.connect("timeout", Callable(self, "_on_timer_timeout"))

##################################################
func _physics_process(delta: float) -> void:
	if not is_instance_valid(controlled_planet):
		return
	
	if in_control:
		controlled_planet.gravity_scale = 0
		
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x -= movement_speed
		controlled_planet.linear_velocity = velocity
	elif Input.is_action_pressed("ui_right"):
		velocity.x += movement_speed
		controlled_planet.linear_velocity = velocity
	elif in_control:
		velocity = Vector2.ZERO
		controlled_planet.linear_velocity = velocity
		
	if Input.is_action_just_pressed("ui_accept"):
		in_control = false
		controlled_planet.gravity_scale = 1
		spawn_timer.start()

##################################################
func _on_timer_timeout() -> void:
	match_planet_type()

##################################################
func match_planet_type() -> void:
	
	var planet_type = next_planet
	match planet_type:
		PlanetType.MOON:
			controlled_planet = moon.instantiate()
		PlanetType.MERCURY:
			controlled_planet = mercury.instantiate()
		PlanetType.MARS:
			controlled_planet = mars.instantiate()
		PlanetType.VENUS:
			controlled_planet = venus.instantiate()
			
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
		
	add_child(controlled_planet)
	controlled_planet.position = init_position
	in_control = true
