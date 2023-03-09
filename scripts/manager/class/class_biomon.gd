# meta-name: Annoted menu screen
# meta-description: Base template with complete annoted code for screen generation in Biotik
"""=============================================
File: class_biomon.gd
Author: Ska
Version: 0.1
Description:
	Base canvas for biomon instance

Changes: 
	0.1
		- file creation

To-do: 
	-(...)
============================================="""

class_name ClassBiomon

# Set up signals

# Set up constants

# Set up variables
var saved_key = "" # Unique key of the biomon in the save folder
var key: String = "1" # key of the biomon
var id: int = 1 # wich biomon it is
var form: int = 0 # wich form
var shiny = false # shiny or not
var name: String = "" # 
var level: int = 1 #


"""=====
Function: generator()
Author: Ska
	Generate a random biomon with stats and all depending on arguments
Arguments
	- id: can be an int or a string or an array (array works for random encounters)
	- level: can be a range or an int
====="""
func _init(new_id, new_level):
	if typeof(new_id) == TYPE_ARRAY:
		var rand_id = RandomNumberGenerator.new()
		rand_id.randomize()
		key = new_id[rand_id.randi_range(0, len(new_id)-1)]
	else:
		key = new_id
	
	if typeof(new_level) == TYPE_ARRAY:
		var rand_lvl = RandomNumberGenerator.new()
		rand_lvl.randomize()
		level = new_level[rand_lvl.randi_range(0, len(new_level)-1)]
	else:
		level = new_level
	
	id = int(key)
	name = DataRead.database.biodex[key].name
	
	return str(name + " lv: " + str(level))

"""=====
Function: new()
Author: Ska
	Creator for the class ClassBiomon

Arguments
	- 
====="""
