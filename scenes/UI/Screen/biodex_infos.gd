extends CanvasLayer

var current_id = 1
var new_id = 1
var transition_id = 1

enum SelectedBt {LOCA, CRI, STATS, RETOUR}
var selected_bt = SelectedBt.LOCA

""" User input """
func _unhandled_input(event):
	""" Switch butons """
	if event.is_action_pressed("ui_right"):
		if $ButonSelect.frame < $ButonSelect.hframes-1:
			$ButonSelect.frame += 1
		else:
			$ButonSelect.frame = 0
	elif event.is_action_pressed("ui_left"):
		if $ButonSelect.frame > 0:
			$ButonSelect.frame -= 1
		else:
			$ButonSelect.frame = $ButonSelect.hframes-1
	
	""" Switch selected buton """
	if $ButonSelect.frame == 0:
		selected_bt = SelectedBt.LOCA
	elif $ButonSelect.frame == 1:
		selected_bt = SelectedBt.CRI
	elif $ButonSelect.frame == 2:
		selected_bt = SelectedBt.STATS
	elif $ButonSelect.frame == 3:
		selected_bt = SelectedBt.RETOUR
	
	""" Accept pressed """
	if event.is_action_pressed("ui_accept"):
		match selected_bt:
			SelectedBt.RETOUR:
				visible = false
	
	""" Biomon id changer """
	if event.is_action_pressed("ui_up"):
		new_id = DataRead.next_id(current_id, -1, "biodex")
		load_biomon(new_id)
	elif event.is_action_pressed("ui_down"):
		new_id = DataRead.next_id(current_id, 1, "biodex")
		load_biomon(new_id)
		
	

""" Load biomon data into the scene """
func load_biomon(id=1):
	current_id = id
	$BiomonSprite.select_sprite(id)
	$Id.text = str(id)
	$Name.text = DataRead.database.biodex[str(id)].name
	$Height.text = str(float(DataRead.database.biodex[str(id)].h) / 100)
	$Weight.text = str(DataRead.database.biodex[str(id)].w)
	$Species.text = DataRead.database.biodex[str(id)].species
	$Desc.text = DataRead.database.biodex[str(id)].desc
	$TypeSprite.load_type(DataRead.database.biodex[str(id)].type1)
	$TypeSprite2.load_type(DataRead.database.biodex[str(id)].type2)
	
