extends Node2D

@onready var wormhole_scene = preload("res://wormhole.tscn")
@onready var level = get_tree().get_first_node_in_group("level")
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

func start_using():
	open_wormhole_a()

func stop_using():
	open_wormhole_b()

func open_wormhole_a():
	wormhole_a.global_position = get_global_mouse_position()
	wormhole_a.visible = true

func open_wormhole_b():
	wormhole_b.global_position = get_global_mouse_position()
	wormhole_b.visible = true

func _physics_process(delta):
	frames_existed += 1
	if frames_existed >= total_frames_to_exist:
		kill_wormholes()

func kill_wormholes():
	wormhole_a.visible = false
	wormhole_b.visible = false


func _on_wormhole_b_area_entered(area): # wormhole b entered
	pass


func _on_wormhole_a_area_entered(area):
	pass # Replace with function body.
