extends Area2D

var damage = 5
var velocity = Vector2.ZERO

func _physics_process(delta):
	global_position += velocity

func _on_area_entered(area):
	if area == "enemy_hitbox":
		area.get_parent().take_damage(damage) # enemy takes damage
		queue_free()
