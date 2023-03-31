
extends Control

var SPRITE_VALUES = {
	"position": [Vector2(64,245), Vector2(64,186), Vector2(64,105), Vector2(64,30), Vector2(64,-20)],
	"scale": [Vector2(0.4,0.4), Vector2(0.6,0.6), Vector2(0.8,0.8), Vector2(0.6,0.6), Vector2(0.4,0.4)]
}
var SPRITE_NB = 5
var sprite_list = []
var where_to_add = [0, -1, 0]
var ScrollManagerNode

const biomon_sprite_holder_path = preload("res://scenes/ui/interface/BiomonSpriteHolder.tscn")

func load_sprite_list(current_biomon_id):
	print("Loading sprite list...")
	sprite_list.push_front(biomon_sprite_holder_path.instance())
	sprite_list[0].visible = false
	sprite_list.push_front(biomon_sprite_holder_path.instance())
	sprite_list[0].visible = false
	for i in range(0, 3):
		sprite_list.push_front(biomon_sprite_holder_path.instance())
		set_new_sprite_parameters(0, DataRead.next_id(current_biomon_id, i))
	print("... sprite list loaded.")

func add_new_sprite_to_list(current_biomon_id, scroll_direction):
	#print("Adding new biomon based on " + str(current_biomon_id) + " with direction " + str(scroll_direction) + " to the list")
	var new_biomon_id = DataRead.next_id(current_biomon_id, scroll_direction*3)
	#print("New biomon id is : " + str(new_biomon_id))
	if sprite_list[0].get_child(0).biomon_id == DataRead.get_highest_biomon_id() and scroll_direction > 0:
		#print("Current id will reach high end : push an invisible sprite")
		sprite_list.push_front(biomon_sprite_holder_path.instance())
		set_new_sprite_parameters(0, DataRead.get_highest_biomon_id())
		sprite_list[0].visible = false
	elif sprite_list[-1].get_child(0).biomon_id == 1 and scroll_direction < 0:
		#print("Current id will reach low end : push an invisible sprite")
		sprite_list.push_back(biomon_sprite_holder_path.instance())
		set_new_sprite_parameters(-1, 1)
		sprite_list[-1].visible = false
	elif scroll_direction > 0:
		sprite_list.push_front(biomon_sprite_holder_path.instance())
		set_new_sprite_parameters(0, new_biomon_id)
	elif scroll_direction < 0:
		sprite_list.push_back(biomon_sprite_holder_path.instance())
		set_new_sprite_parameters(-1, new_biomon_id)
	if sprite_list.size() > SPRITE_NB:
		if scroll_direction > 0:
			#print("Deleting low end sprite")
			sprite_list[-1].queue_free()
			sprite_list.pop_back()
		else:
			#print("Deleting high end sprite")
			sprite_list[0].queue_free()
			sprite_list.pop_front()

func set_new_sprite_parameters(position_in_list, new_biomon_id):
	#print("setting new parameters for " + str(new_biomon_id) + " at " + str(position_in_list))
	
	add_child(sprite_list[position_in_list])
	sprite_list[position_in_list].get_child(0).select_sprite(new_biomon_id)
	sprite_list[position_in_list].position = SPRITE_VALUES.position[position_in_list]
	sprite_list[position_in_list].scale = SPRITE_VALUES.scale[position_in_list]
	#print("Position in node : " + str(SPRITE_VALUES.position[position_in_list]))

func prepare_sprites_parameters():
	var new_sprite_parameters = []

	for i in range(0, SPRITE_NB):
		new_sprite_parameters.append([SPRITE_VALUES.position[i], SPRITE_VALUES.scale[i]])
	
	return new_sprite_parameters
	
func get_sprite_list():
	return sprite_list
