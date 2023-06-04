extends ClassScreen

# Nodes
var box_list = null
var current_box = null
var biodex_list = null

""" Called when the scene manager load the scene """
func _load_screen():	
	box_list = get_node("%OptionButon")
	current_box = get_node("%CurrentBox")
	biodex_list = get_node("%BiodexList")
	
	box_list.load_buttons()
	current_box.load_current_box(Utils.get_party_manager().party_node_to_array())
	biodex_list.load_biomon_list()
	
	get_node("Player").set_physics_process(false)

""" Called when the scene manager exit the scene """
func _pack_scene():
	# Use this to store some new keys into scene_parameters
	pass

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		exit_scene("res://scenes/debug/DebugMain.tscn")
