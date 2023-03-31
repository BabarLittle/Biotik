extends Node2D

var biomon_id

func set_biomon_to_show(new_biomon_id):
	biomon_id = new_biomon_id
	$state.frame = DataRead.get_biomon_known_state(biomon_id)
	$text.text = str(biomon_id) + " " + DataRead.database.biodex[str(biomon_id)].name
