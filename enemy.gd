extends Node2D

@onready var animation_player = get_node("AnimationPlayer")
@onready var healthbar = get_node("Label")
var health = 100

func _ready():
	healthbar.text = str(health)

func take_damage(damage):
	animation_player.play("take_damage")
	health -= damage
	if health <= 0:
		die()
	healthbar.text = str(health)

func die():
	animation_player.play("die")
