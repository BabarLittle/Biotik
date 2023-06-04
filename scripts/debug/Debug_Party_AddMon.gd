extends Button



func _on_Button_pressed():
	var item_node = get_node("%BiodexList")
	var biomon_key = DataRead.get_id_from_name(item_node.text)
	Utils.get_party_manager().new_biomon(biomon_key)
