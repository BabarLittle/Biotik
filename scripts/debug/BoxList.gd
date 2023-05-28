extends OptionButton

var display_box

func load_buttons():
	add_item("PartyBox", 0)
	for i in range(1, Utils.get_party_manager().get_box().size()+1):
		add_item(Utils.get_party_manager().get_box(i-1).name, i)
	grab_focus()
	
	display_box = get_node("%CurrentBox")
	

func item_selected(index):
	if index == 0:
		display_box.load_current_box(Utils.get_party_manager().party_node_to_array())
	else:
		display_box.load_current_box(Utils.get_party_manager().get_box(index-1).slots)
