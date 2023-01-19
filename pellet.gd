extends Area2D

var damage = 5
var velocity = Vector2.ZERO

func _physics_process(delta):
	global_position += velocity

func _on_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		area.get_parent().take_damage(damage) # enemy takes damage
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("tilemap"):
		queue_free()
