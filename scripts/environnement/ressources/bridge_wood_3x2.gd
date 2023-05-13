extends ClassMapObject

enum TypeBridge {H=0, V=1, SQUARE=2}

var type_bridge = TypeBridge.H
var first_check = true

func _body_entered_script(body):
	if body.name == player_body_name:
		if first_check and type_bridge == TypeBridge.SQUARE:
			first_check = false
			check_neighboorhood()
		body.set_collision_mask_bit(5, false)
	print("Player entered '" + str(self) + "' and it overlaps " + str(object_area.get_overlapping_areas().size()) + " areas :")
	if object_area.get_overlapping_areas().size() > 0:
		print(str(object_area.get_overlapping_areas()) + " child of " + str(object_area.get_overlapping_areas()[0].get_parent()))

func _body_exited_script(body):
	if body.name == player_body_name and !check_neighboors_bridges():
		body.set_collision_mask_bit(5, true)
	
func _specifics_parameters():	
	type_bridge = object_sprite.frame
	load_shapes_bridge()
	load_sprite_bridge()

func _interact_action():
	pass
	
func _dialogue_feedback(_feedback):
	pass
	
func load_shapes_bridge():
	$LeftCollider.disabled = true
	$RightCollider.disabled = true
	$Area2D/AreaH.disabled = true
	$TopCollider.disabled = true
	$BotCollider.disabled = true
	$Area2D/AreaV.disabled = true
	$SmallLeftCollider.disabled = true
	$SmallRightCollider.disabled = true
	$Area2D/SmallAreaH.disabled = true
	$SmallTopCollider.disabled = true
	$SmallBotCollider.disabled = true
	$Area2D/SmallAreaV.disabled = true
	
	match type_bridge:
		TypeBridge.H:
			$SmallTopCollider.disabled = false
			$SmallBotCollider.disabled = false
			$Area2D/SmallAreaH.disabled = false
			
		TypeBridge.V:
			$SmallLeftCollider.disabled = false
			$SmallRightCollider.disabled = false
			$Area2D/SmallAreaV.disabled = false
			
		TypeBridge.SQUARE:
			$Area2D/AreaH.disabled = false
			$Area2D/AreaV.disabled = false
			
		
func load_sprite_bridge():
	object_sprite.frame = 0
	object_sprite.hframes = 1
	object_sprite.region_enabled = true
	
	match type_bridge:
		TypeBridge.H:
			object_sprite.region_rect = Rect2(0,0,16,32)
		TypeBridge.V:
			object_sprite.region_rect = Rect2(16,32,32,16)
		TypeBridge.SQUARE:
			object_sprite.region_rect = Rect2(16,0,32,32)
	
func check_neighboorhood():
	for area in object_area.get_overlapping_areas():
		print(area)
		if "Bridge" in area.get_parent().name:
			var relative_position = position - area.get_parent().position
			print(relative_position.normalized())
			match relative_position.normalized():
				Vector2.UP:
					$TopCollider.set_deferred("disabled", true)
					$TopCollider.set_deferred("visible", false)
				Vector2.LEFT:
					$LeftCollider.set_deferred("disabled", true)
					$LeftCollider.set_deferred("visible", false)
				Vector2.RIGHT:
					$RightCollider.set_deferred("disabled", true)
					$RightCollider.set_deferred("visible", false)
				Vector2.DOWN:
					$BotCollider.set_deferred("disabled", true)
					$BotCollider.set_deferred("visible", false)
	
	var tileset_water = Utils.get_current_scene().get_node("Water")
	var position_tileset_water = tileset_water.world_to_map(position-object_sprite.offset)
	print(position_tileset_water + 2*Vector2.UP)
	print(tileset_water.get_cellv(position_tileset_water + 2*Vector2.UP))
	if tileset_water.get_cellv(position_tileset_water + 2*Vector2.UP) == -1:
		$TopCollider.set_deferred("disabled", true)
		$TopCollider.set_deferred("visible", false)
	if tileset_water.get_cellv(position_tileset_water + Vector2.DOWN) == -1:
		$BotCollider.set_deferred("disabled", true)
		$BotCollider.set_deferred("visible", false)
	if tileset_water.get_cellv(position_tileset_water + Vector2.LEFT) == -1:
		$LeftCollider.set_deferred("disabled", true)
		$LeftCollider.set_deferred("visible", false)
	if tileset_water.get_cellv(position_tileset_water + 2*Vector2.RIGHT) == -1:
		$RightCollider.set_deferred("disabled", true)
		$RightCollider.set_deferred("visible", false)
	
	

func check_neighboors_bridges():
	for area in object_area.get_overlapping_areas():
		if "Bridge" in area.get_parent().name:
			if area.get_parent().player_inside:
				return true
	return false
