extends GridContainer

var box

""" Called when the scene manager load the scene """
func load_current_box(box_id):
	var i = 0
	box = Utils.get_party_manager().get_box(box_id)
	
	for child in get_children():
		if not "Sprite" in child.name:
			child.load_buton(box[i])
			i += 1
