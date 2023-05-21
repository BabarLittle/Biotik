extends Node2D

onready var torchlight = $TorchLight
onready var interact_cast = $InteractRayCast2D


func turn(new_angle):
	# Torch
	var old_rotation = rotation_degrees
	var new_rotation = rad2deg(new_angle.angle())
	var rotating_value = fix_tool_rotation(new_rotation - old_rotation)
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "rotation_degrees",
		old_rotation+rotating_value, 0.2).from(old_rotation)

func fix_tool_rotation(angle):
	if abs(angle) > 180:
		angle = wrapi(angle -360,-180,180)
	return angle
