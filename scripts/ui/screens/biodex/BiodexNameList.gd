
extends Control

var name_VALUES = {
	"position_x": [20, 2],
	"position_y": [272, 272, 129, -12],
	"jump_y": [27, 37, 36],
	"scale": [Vector2(0.8,0.8), Vector2(1,1), Vector2(0.8,0.8)]
}
var name_NB = 11
var name_list = []
var where_to_add = [0, -1, 0]
var ScrollManagerNode

const biomon_name_holder_path = preload("res://scenes/ui/screens/biodex/BiodexLabelList.tscn")

func load_name_list(current_biomon_id):
	print("Loading name list...")
	for _i in range(0,5):
		name_list.push_front(biomon_name_holder_path.instance())
		name_list[0].visible = false

	for i in range(0, 6):
		name_list.push_front(biomon_name_holder_path.instance())
		set_new_name_parameters(0, DataRead.next_id(current_biomon_id, i))
	print("... name list loaded.")

func add_new_name_to_list(current_biomon_id, scroll_direction):
	#print("Adding new biomon based on " + str(current_biomon_id) + " with direction " + str(scroll_direction) + " to the list")
	var new_biomon_id = DataRead.next_id(current_biomon_id, scroll_direction*6)
	#print("New biomon id is : " + str(new_biomon_id))
	if name_list[0].biomon_id == DataRead.get_highest_biomon_id() and scroll_direction > 0:
		#print("Current id will reach high end : push an invisible name")
		name_list.push_front(biomon_name_holder_path.instance())
		set_new_name_parameters(0, DataRead.get_highest_biomon_id())
		name_list[0].visible = false
	elif name_list[-1].biomon_id == 1 and scroll_direction < 0:
		#print("Current id will reach low end : push an invisible name")
		name_list.push_back(biomon_name_holder_path.instance())
		set_new_name_parameters(-1, 1)
		name_list[-1].visible = false
	elif scroll_direction > 0:
		name_list.push_front(biomon_name_holder_path.instance())
		set_new_name_parameters(0, new_biomon_id)
	elif scroll_direction < 0:
		name_list.push_back(biomon_name_holder_path.instance())
		set_new_name_parameters(-1, new_biomon_id)
	if name_list.size() > name_NB:
		if scroll_direction > 0:
			#print("Deleting low end name")
			name_list[-1].queue_free()
			name_list.pop_back()
		else:
			#print("Deleting high end name")
			name_list[0].queue_free()
			name_list.pop_front()

func set_new_name_parameters(position_in_list, new_biomon_id):
	#print("setting new parameters for " + str(new_biomon_id) + " at " + str(position_in_list))
	
	add_child(name_list[position_in_list])
	#print(name_list[position_in_list].get_parent())
	name_list[position_in_list].set_biomon_to_show(new_biomon_id)
	name_list[position_in_list].position.x = name_VALUES.position_x[0]
	name_list[position_in_list].position.y = name_VALUES.position_y[position_in_list]
	name_list[position_in_list].scale = name_VALUES.scale[position_in_list]
	#print("Position in node : " + str(name_VALUES.position[position_in_list]))

func prepare_names_parameters():
	var new_name_parameters = []

	for i in range(0, name_NB):
		if i < name_NB / 2:
			new_name_parameters.append([Vector2(name_VALUES.position_x[0], name_VALUES.position_y[1]-i*name_VALUES.jump_y[0]), name_VALUES.scale[0]])
		elif i == name_NB / 2:
			new_name_parameters.append([Vector2(name_VALUES.position_x[1], name_VALUES.position_y[2]), name_VALUES.scale[1]])
		else:
			new_name_parameters.append([Vector2(name_VALUES.position_x[0], name_VALUES.position_y[1]-i*name_VALUES.jump_y[0]-17), name_VALUES.scale[0]])
	
	return new_name_parameters
	
func get_name_list():
	#print(name_list.size())
	return name_list
