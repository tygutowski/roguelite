extends Node2D

@onready var wormhole_scene = preload("res://wormhole.tscn")
@onready var level = get_tree().get_first_node_in_group("level")
@onready var player = get_tree().get_first_node_in_group("player")
var wormhole
var wormhole_a
var wormhole_b
var total_frames_to_exist = 300
var frames_existed = 0

func _ready():
	var wormhole = wormhole_scene.instantiate()
	level.add_child(wormhole)
	wormhole_a = get_node("WormholeA")
	wormhole_b = get_node("WormholeB")

func is_in_line_of_signt(position1, position2):
	var ray = RayCast2D.new()
	ray.global_position = position1
	ray.target_position = position2
	ray.enabled = true
	ray.force_raycast_update()
	return !ray.is_colliding()

func start_using():
	if is_in_line_of_signt(get_global_mouse_position(), player.global_position):
		open_wormhole_a()
	else:
		kill_wormhole_a()
func stop_using():
	if wormhole_a.visible:
		if is_in_line_of_signt(wormhole_a, get_global_mouse_position()):
			open_wormhole_b()
		else:
			kill_wormholes()
func open_wormhole_a():
	wormhole_a.global_position = get_global_mouse_position()
	wormhole_a.visible = true
	wormhole_a.get_node("Area2D/CollisionShape2D").disabled = false

func open_wormhole_b():
	wormhole_b.global_position = get_global_mouse_position()
	wormhole_b.visible = true
	wormhole_b.get_node("Area2D/CollisionShape2D").disabled = false

func _physics_process(delta):
	frames_existed += 1
	if frames_existed >= total_frames_to_exist:
		kill_wormholes()

func kill_wormholes():
	kill_wormhole_a()
	kill_wormhole_b()

func kill_wormhole_a():
	wormhole_a.visible = false
	wormhole_a.get_node("Area2D/CollisionShape2D").disabled = true

func kill_wormhole_b():
	wormhole_b.visible = false
	wormhole_b.get_node("Area2D/CollisionShape2D").disabled = true

func _on_wormhole_b_area_entered(area): # wormhole b entered
	if area.is_in_group("ally_projectile"):
		area.global_position = wormhole_b.global_position

func _on_wormhole_a_area_entered(area):
	if area.is_in_group("ally_projectile"):
		area.global_position = wormhole_a.global_position
