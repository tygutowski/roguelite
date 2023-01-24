extends CharacterBody2D

@export var speed = 200
@export var friction = 1
@export var acceleration = 0.9

@onready var animation_player = get_node("AnimationPlayer")

var primary
var secondary
var mobility
var offensive
var defensive

var last_x_axis
var last_y_axis
var x_axis
var y_axis
var base_attack_speed = 1 # in shots per second
var attack_speed_modifier = 1
var first_dir_pressed = "none"

var potential_abilities = {
	"primary": null,
	"secondary": null,
	"mobility": null,
	"offensive": null,
	"defensive": null
	}

func _ready():
	last_x_axis = 1
	last_y_axis = 1
	primary = load("res://shotgun.tscn").instantiate()
	potential_abilities["primary"] = primary
	get_node("Abilities").add_child(primary)
	
	secondary = load("res://pocket_wormhole.tscn").instantiate()
	potential_abilities["secondary"] = secondary
	get_node("Abilities").add_child(secondary)
	
func get_input():
	
	x_axis = Input.get_action_raw_strength('east') - Input.get_action_raw_strength('west')
	y_axis = Input.get_action_raw_strength('south') - Input.get_action_raw_strength('north')
	if x_axis != 0:
		last_x_axis = x_axis
	if y_axis != 0:
		last_y_axis = y_axis
	if first_dir_pressed == "none":
		if x_axis > 0:
			first_dir_pressed = "east"
		elif x_axis < 0:
			first_dir_pressed = "west"
		elif y_axis > 0:
			first_dir_pressed = "south"
		elif y_axis < 0:
			first_dir_pressed = "north"
	if x_axis == 0 && y_axis == 0:
		first_dir_pressed = "none" # 0 1234 NONE NESW
		if last_x_axis > 0: # right
			animation_player.current_animation = "idle_east"
		elif last_x_axis < 0: # left
			animation_player.current_animation = "idle_west"
	if first_dir_pressed == "north": # NORTH
		animation_player.current_animation = "run_north"
		if y_axis >= 0:
			first_dir_pressed = "none"
	elif first_dir_pressed == "east": # EAST
		animation_player.current_animation = "run_east"
		if x_axis <= 0:
			first_dir_pressed = "none"
	elif first_dir_pressed == "south": # SOUTH
		animation_player.current_animation = "run_south"
		if y_axis <= 0:
			first_dir_pressed = "none"
	elif first_dir_pressed == "west": # WEST
		animation_player.current_animation = "run_west"
		if x_axis >= 0:
			first_dir_pressed = "none"
		

	else: # movement
		if x_axis > 0: # right
			pass
		elif x_axis < 0: # left
			pass
	return Vector2(x_axis, y_axis)

func _physics_process(_delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()

func _process(_delta):
	for ability in potential_abilities:
		if Input.is_action_just_pressed(ability) && potential_abilities[ability]:
			potential_abilities[ability].start_using()
		elif Input.is_action_just_released(ability) && potential_abilities[ability]:
			potential_abilities[ability].stop_using()
