extends Node2D

var health = 100

func take_damage(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()
