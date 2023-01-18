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

var potential_abilities = {
	"primary": null,
	"secondary": null,
	"mobility": null,
	"offensive": null,
	"defensive": null
	}

func _ready():
	primary = load("res://shotgun.tscn").instantiate()
	potential_abilities["primary"] = primary
	get_node("Abilities").add_child(primary)

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

func _process(_delta):
	for ability in potential_abilities:
		if Input.is_action_just_pressed(ability) && potential_abilities[ability]:
			potential_abilities[ability].start_using()
		elif Input.is_action_just_released(ability) && potential_abilities[ability]:
			potential_abilities[ability].stop_using()
