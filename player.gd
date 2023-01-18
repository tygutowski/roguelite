extends CharacterBody2D

@export var speed = 200
@export var friction = 0.9
@export var acceleration = 0.9

var primary
var secondary
var mobility
var offensive
var defensive

var base_attack_speed = 1 # in shots per second
var attack_speed_modifier = 1

func _ready():
	primary = load("res://shotgun.tscn").instantiate()
	add_child(primary)

func get_input():
	var input = Vector2()
	var y_axis = Input.get_action_raw_strength('down') - Input.get_action_raw_strength('up')
	var x_axis = Input.get_action_raw_strength('right') - Input.get_action_raw_strength('left')
	return Vector2(x_axis, y_axis)

func _physics_process(delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()

var potential_inputs = ["primary", "secondary", "mobility", "offensive", "defensive"]
var potential_abilities = [primary, secondary, mobility, offensive, defensive]

func _process(_delta):
	for i in range(len(potential_inputs)):
		if Input.is_action_just_pressed(potential_inputs[i]) && potential_abilities[i]:
			potential_abilities[i].start_using()
		elif Input.is_action_just_released(potential_inputs[i]) && potential_abilities[i]:
			potential_abilities[i].stop_using()
