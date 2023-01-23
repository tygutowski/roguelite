extends Node2D

var max_ammo = 4
var ammo = max_ammo
var shooting = false

@onready var player = get_tree().get_first_node_in_group("player")
@onready var level = get_tree().get_first_node_in_group("level")
var frames_between_shots
var frames_since_last_shot
var frames_to_fully_charge = 60
var frames_charged = 0
@onready var arm = player.get_node("Arm")
@onready var hand = arm.get_node("Hand")

func _ready():
	frames_charged = 0
	update_stats()
	frames_since_last_shot = frames_between_shots

func start_using():
	frames_charged = 0
	update_stats()
	shooting = true

func stop_using():
	frames_charged = 0
	shooting = false

func _process(_delta):
	aim()
	frames_since_last_shot += 1
	if shooting && frames_since_last_shot >= frames_between_shots:
		frames_charged += 1
		if frames_charged >= frames_to_fully_charge:
			shoot()

func shoot():
	frames_charged = 0
	frames_since_last_shot = 0
	var aiming_at = (get_global_mouse_position())*1000

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

func update_stats():
	frames_between_shots = floor(clamp(60.0 / player.base_attack_speed * player.attack_speed_modifier, 1, INF))
