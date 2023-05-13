extends ClassMapObject

func _body_entered_script(body):
	if body.name == player_body_name:
		body.set_collision_mask_bit(5, false)
	print("Player entered '" + str(self) + "' and it overlaps " + str(object_area.get_overlapping_areas().size()) + " areas :")
	if object_area.get_overlapping_areas().size() > 0:
		print(str(object_area.get_overlapping_areas()) + " child of " + str(object_area.get_overlapping_areas()[0].get_parent()))

func _body_exited_script(body):
	if body.name == player_body_name and !check_neighboors_bridges():
		body.set_collision_mask_bit(5, true)
	
func _specifics_parameters():
	load_h_bridge(object_sprite.frame == 0)

func _interact_action():
	pass
	
func _dialogue_feedback(_feedback):
	pass
	
func load_h_bridge(h_bridge: bool):
	$LeftCollider.disabled = h_bridge
	$RightCollider.disabled = h_bridge
	$Area2D/AreaH.disabled = !h_bridge
	$TopCollider.disabled = !h_bridge
	$BotCollider.disabled = !h_bridge
	$Area2D/AreaV.disabled = h_bridge
	
func check_neighboors_bridges():
	for area in object_area.get_overlapping_areas():
		if "Bridge" in area.get_parent().name:
			if area.get_parent().player_inside:
				return true
	return false
