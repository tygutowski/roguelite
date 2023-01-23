extends Sprite2D
@onready var rotating = get_node("CrosshairRotating")
func _process(_delta):
	global_position = get_global_mouse_position()
	rotating.rotate(deg_to_rad(1))
