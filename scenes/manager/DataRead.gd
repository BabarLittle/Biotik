""" Auto-load file to load all game data"""

extends Node

var biodex

func _ready():
	""" Load biodex """
	var biodex_file = File.new()
	biodex_file.open("res://data/biodex.json", File.READ)
	var biodex_json = JSON.parse(biodex_file.get_as_text())
	biodex_file.close()
	biodex = biodex_json.result
	
	""" Load moves """
	# wip...
