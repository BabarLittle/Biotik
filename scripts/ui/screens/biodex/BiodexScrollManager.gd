extends Tween

var SpriteListNode
var NameListNode
var SideBarNode
var side_bar_fraction = 1
var current_biomon_id = 1
export(float) var SCROLLING_TIME = 0.3

func load_scroll_manager(sprite_list_node, name_list_node, side_bar_node, new_current_biomon_id):
	print("Loading scroll manager...")
	SpriteListNode = sprite_list_node
	NameListNode = name_list_node
	SideBarNode = side_bar_node
	side_bar_fraction = get_parent().get_node("Interface/SideBar").rect_size.y / DataRead.get_biomon_numbers()
	
	SpriteListNode.load_sprite_list(current_biomon_id)
	update_sprites_position(10)
	
	NameListNode.load_name_list(current_biomon_id)
	update_names_position(10)
	var scroll_value = DataRead.get_biomon_id_distance(current_biomon_id, new_current_biomon_id)
	if scroll_value != 0:
		scrolling_biodex(scroll_value)
	print("... scroll manager loaded.")

func scrolling_biodex(scroll_value):
	print(is_active())
	if !is_active():
		var steps = 0
		var scroll_direction = abs(scroll_value)/scroll_value
		print("=======")
		print("Scrolling biodex with scroll direction = " + str(scroll_value))
		while steps != abs(scroll_value):
			steps += 1
			if !is_current_id_at_extremity(scroll_direction):
				SpriteListNode.add_new_sprite_to_list(current_biomon_id, scroll_direction)
				NameListNode.add_new_name_to_list(current_biomon_id, scroll_direction)
				update_sprites_position(abs(scroll_value))
				update_names_position(abs(scroll_value))
				update_scrollbar_position(scroll_direction, abs(scroll_value))
				current_biomon_id = DataRead.next_id(current_biomon_id, scroll_direction)
				yield(self, "tween_all_completed")
			else:
				print("Scrolling blocked : we've reached an extremity !")
				break
		print(is_active())

func update_scrollbar_position(scroll_direction, speed_modifier):
	var transition_time = SCROLLING_TIME / speed_modifier
	interpolate_property(SideBarNode, "rect_position",
	SideBarNode.rect_position, Vector2(0, side_bar_fraction*current_biomon_id), transition_time,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
func update_sprites_position(speed_modifier) -> void:
	var transition_time = SCROLLING_TIME / speed_modifier
	var sprite_list = SpriteListNode.get_sprite_list()
	var new_parameters_list = SpriteListNode.prepare_sprites_parameters()
	
	#print("Updating sprites positions...")
	for i in range(len(sprite_list)):
		#print("Biomon " + str(sprite_list[i].get_child(0).biomon_id) + " (" + str(i) + " in list) : " + str(new_parameters_list[i][0]))
		interpolate_property(sprite_list[i], "position",
		sprite_list[i].position, new_parameters_list[i][0], transition_time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		interpolate_property(sprite_list[i], "scale",
		sprite_list[i].scale, new_parameters_list[i][1], transition_time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	start()
	
func update_names_position(speed_modifier) -> void:
	var transition_time = SCROLLING_TIME / speed_modifier
	var name_list = NameListNode.get_name_list()
	var new_parameters_list = NameListNode.prepare_names_parameters()
	
	for i in range(len(name_list)):
		#print("Biomon " + str(name_list[i].biomon_id) + " (" + str(i) + " in list) : " + str(new_parameters_list[i][0]))
		interpolate_property(name_list[i], "position",
		name_list[i].position, new_parameters_list[i][0], transition_time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		interpolate_property(name_list[i], "scale",
		name_list[i].scale, new_parameters_list[i][1], transition_time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	start()
	
func get_current_biomon_id() -> int:
	return current_biomon_id
	
func is_current_id_at_extremity(scroll_direction) -> bool:
	var temp_list_extremity = [0, 1, DataRead.get_highest_biomon_id()]
	if current_biomon_id == temp_list_extremity[-(abs(scroll_direction)/scroll_direction)]:
		return true
	else:
		return false

func _on_ScrollManager_tween_all_completed():
	print("Tweens OK")


func _on_ScrollManager_tween_completed(object, key):
	print("Tween : " + str(object) + " with " + str(key) + " has finished")
