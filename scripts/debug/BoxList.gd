extends OptionButton

func load_buttons():
	add_item("PartyBox", 0)
	for i in range(1, Utils.get_party_manager().get_box().size()+1):
		add_item(Utils.get_party_manager().get_box(i-1).name, i)
	grab_focus()
	
func control_viewport():
	pass

func item_selcted(index):
	index = index - 1
	
	if index == 0:
		pass
	else:
		pass
		
