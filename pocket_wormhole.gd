extends Node2D

var cooldown = 4.0 # seconds
@onready var wormhole_scene = preload("res://wormhole.tscn")
@onready var level = get_tree().get_first_node_in_group("level")
@onready var player = get_tree().get_first_node_in_group("player")
var wormhole_a = null
var wormhole_b = null
var total_frames_to_exist = 300
var frames_existed = 0

func is_in_line_of_sight(position1, position2):
	if is_inside_tree():
		var ray = RayCast2D.new()
		ray.global_position = position1
		ray.target_position = position2
		ray.enabled = true
		level.add_child(ray)
		ray.force_raycast_update()
		return !ray.is_colliding()

func start_using():
	kill_wormholes()
	frames_existed = 0
	if is_in_line_of_sight(get_global_mouse_position(), player.global_position) && wormhole_a == null:
		open_wormhole_a()
	else:
		kill_wormhole_a()

func stop_using():
	frames_existed = 0
	if wormhole_a:
		if is_in_line_of_sight(wormhole_a.global_position, get_global_mouse_position()) && wormhole_b == null:
			open_wormhole_b()
		else:
			kill_wormholes()

func open_wormhole_a():
	wormhole_a = wormhole_scene.instantiate()
	level.add_child(wormhole_a)
	wormhole_a.global_position = get_global_mouse_position()
	wormhole_a.area_entered.connect(_wormhole_a_area_entered)
	
func open_wormhole_b():
	wormhole_b = wormhole_scene.instantiate()
	level.add_child(wormhole_b)
	wormhole_b.global_position = get_global_mouse_position()
	wormhole_b.area_entered.connect(_wormhole_b_area_entered)
	
func _physics_process(_delta):
	frames_existed += 1
	if frames_existed >= total_frames_to_exist:
		kill_wormholes()

func kill_wormholes():
	kill_wormhole_a()
	kill_wormhole_b()

func kill_wormhole_a():
	if wormhole_a != null:
		wormhole_a.queue_free()
		wormhole_a = null

func kill_wormhole_b():
	if wormhole_b != null:
		wormhole_b.queue_free()
		wormhole_b = null

func _wormhole_a_area_entered(area):
	if area.is_in_group("ally_projectile") && wormhole_b && area.frames_since_displacement >= 3:
		area.displacement_offset = area.global_position - wormhole_a.global_position
		area.frames_since_displacement = 0
		area.global_position = wormhole_b.global_position + area.displacement_offset
		area.displacement_offset = Vector2.ZERO

func _wormhole_b_area_entered(area):
	if area.is_in_group("ally_projectile")  && wormhole_a && area.frames_since_displacement >= 3:
		area.displacement_offset = area.global_position - wormhole_b.global_position
		area.frames_since_displacement = 0
		area.global_position = wormhole_a.global_position + area.displacement_offset
		area.displacement_offset = Vector2.ZERO
