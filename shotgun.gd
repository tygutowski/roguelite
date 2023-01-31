extends Node2D

var max_ammo = 4
var ammo = max_ammo
var shooting = false

var spread = 20.0 # in degrees
var pellets = 4
var projectile_speed = 10.0
var speed_randomness = 4

var frames_between_shots
var frames_since_last_shot

@onready var player = get_tree().get_first_node_in_group("player")
@onready var pellet_scene = preload("res://pellet.tscn") 
@onready var level = get_tree().get_first_node_in_group("level")
@onready var arm = player.get_node("Arm")
@onready var hand = arm.get_node("Hand")

func _ready():
	update_stats()
	#global_position = player.get_node("Hand").global_position
	frames_since_last_shot = frames_between_shots

func start_using():
	update_stats()
	shooting = true

func stop_using():
	shooting = false

func _process(_delta):
	aim()
	#rotation += get_angle_to(get_global_mouse_position())
	frames_since_last_shot += 1
	if shooting && frames_since_last_shot >= frames_between_shots:
		for pellet in pellets:
			instance_pellet()
		frames_since_last_shot = 0

func aim():
	var hand_distance = 7
	var mouse_pos = get_global_mouse_position()
	var mouse_dir = (mouse_pos - arm.global_position).normalized()
	var arm_to_hand_distance = arm.global_position.distance_to(mouse_pos)
	if arm_to_hand_distance > hand_distance: # outside
		hand.global_position = arm.global_position + mouse_dir * hand_distance
	else: # inside
		hand.global_position = arm.global_position + mouse_dir * arm_to_hand_distance
	rotation = arm.get_angle_to(hand.global_position)
	global_position = hand.global_position
	if rotation >= deg_to_rad(-90) && rotation <= deg_to_rad(0): 
		get_node("Sprite2D").flip_v = false
	elif rotation >= deg_to_rad(-180) && rotation <= deg_to_rad(-90): 
		get_node("Sprite2D").flip_v = true
	elif rotation >= deg_to_rad(0) && rotation <= deg_to_rad(90): 
		get_node("Sprite2D").flip_v = false
	elif rotation >= deg_to_rad(90) && rotation <= deg_to_rad(180): 
		get_node("Sprite2D").flip_v = true
func instance_pellet():
	var projectile = pellet_scene.instantiate()
	projectile.global_position = $Sprite2D/Barrel.global_position
	var vector_to_mouse = (get_global_mouse_position() - arm.global_position).normalized()
	var randomness = deg_to_rad(randf_range(-spread/2, spread/2))
	vector_to_mouse = vector_to_mouse.rotated(randomness)
	projectile.rotation = rotation + randomness
	var speed = randf_range(projectile_speed-speed_randomness/2, projectile_speed+speed_randomness/2)
	projectile.velocity = vector_to_mouse * speed
	level.add_child(projectile)

func update_stats():
	frames_between_shots = floor(clamp(60.0 / player.base_attack_speed * player.attack_speed_modifier, 1, INF))
