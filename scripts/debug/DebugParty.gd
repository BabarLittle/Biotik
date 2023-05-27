extends ClassScreen

var box_list = null
var current_box = null

""" Called when the scene manager load the scene """
func _load_screen():	
	box_list = $UI/MarginContainer/COLUMNS/BIOMONS/OptionButton
	box_list.load_buttons()
	current_box = get_node("%CurrentBox")
	current_box.load_current_box(0)

""" Called when the scene manager exit the scene """
func _pack_scene():
	# Use this to store some new keys into scene_parameters
	pass
