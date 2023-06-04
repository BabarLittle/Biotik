extends OptionButton

func load_biomon_list():
	for key in DataRead.database.biodex.keys():
		add_item(DataRead.database.biodex[key].name)

func item_selected(id):
	pass
