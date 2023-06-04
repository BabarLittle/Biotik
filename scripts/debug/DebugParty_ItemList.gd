extends GridContainer

var box

""" Called when the scene manager load the scene """
func load_current_box(box_obj):
	var i = 0
	box = box_obj
	
	if box == null:
		return
	
	for child in get_children():
		if not "Sprite" in child.name:
			if i >= box.size():
				child.load_buton(null)
			else:
				child.load_buton(box[i])
				i += 1


func _on_CurrentBox_focus_exited():
	print("Test") # Replace with function body.
