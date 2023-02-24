extends CanvasLayer

var current_id = 1

func _ready():
	load_biomon()

""" User input """
func _unhandled_input(event):
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
			
	if event.is_action_pressed("ui_up"):
		if current_id > 1:
			load_biomon(str(current_id-1))
		else:
			load_biomon(str(DataRead.biodex.size()))
	elif event.is_action_pressed("ui_down"):
		if current_id < DataRead.biodex.size():
			load_biomon(str(current_id+1))
		else:
			load_biomon("1")

""" Load biomon data into the scene """
func load_biomon(id=str(current_id)):
	current_id = int(id)
	$BiomonSprite.texture = load("res://Assets/Biomons/" + DataRead.biodex[id].name + ".png")
	$Id.text = id
	$Name.text = DataRead.biodex[id].name
	$Height.text = str(DataRead.biodex[id].h / 100)
	$Weight.text = str(DataRead.biodex[id].w)
	$Species.text = DataRead.biodex[id].species
	$Desc.text = DataRead.biodex[id].desc
	$TypeSprite.load_type(DataRead.biodex[id].type1)
	$TypeSprite2.load_type(DataRead.biodex[id].type2)
	
