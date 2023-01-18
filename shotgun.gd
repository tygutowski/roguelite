extends Node2D

var max_ammo = 4
var ammo = max_ammo
var shooting = false

var spread = 10.0 # in degrees
var pellets = 10
var projectile_speed = 10.0
var speed_randomness = 2.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var pellet_scene = preload("res://pellet.tscn") 
@onready var level = get_tree().get_first_node_in_group("level")
var frames_between_shots
var frames_since_last_shot = 0

func start_using():
	update_stats()
	shooting = true

func stop_using():
	shooting = false

func _process(_delta):
	rotation = get_angle_to(get_global_mouse_position())
	frames_since_last_shot -= 1
	if shooting && frames_since_last_shot >= frames_between_shots:
		for pellet in pellets:
			instance_pellet()
		frames_since_last_shot = 0

func instance_pellet():
	var projectile = pellet_scene.instantiate()
	projectile.rotation = rotation + randf_range(-spread/2, spread/2)
	projectile.global_position = $Barrel.global_position
	projectile.velocity = Vector2(randf_range(projectile_speed-speed_randomness/2, projectile_speed+speed_randomness/2),0)
	level.add_child(projectile)

func update_stats():
	frames_between_shots = floor(clamp(60.0 / player.base_attack_speed * player.attack_speed_modifier, 1, INF))
	frames_since_last_shot = frames_between_shots
