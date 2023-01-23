extends Area2D

var displacement_offset = Vector2.ZERO
var damage = 5
var velocity = Vector2.ZERO
@onready var audio_player = get_node("AudioStreamPlayer2D")
var frames_since_displacement = 5

func _physics_process(_delta):
	global_position += velocity
	frames_since_displacement += 1

func _on_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		area.get_parent().take_damage(damage) # enemy takes damage
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("tilemap"):
		#audio_player.play()
		#await audio_player.finished
		queue_free()
