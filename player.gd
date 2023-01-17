extends CharacterBody2D

@export var speed = 200
@export var friction = 0.9
@export var acceleration = 0.9

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
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
