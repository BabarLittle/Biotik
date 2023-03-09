"""=============================================
File: EncounterDebug.gd
Author: 
Version: 0.1
Description:
	Tests for encounter generation

Changes: 
	0.1 (Author)
		- file creation
		- (...)

To-do: 
	-(...)
============================================="""

extends ClassScreen

# temp var
var dict_test_biomon = {}
var temp_dict = null

""" Called when the scene manager load the scene """
func _load_screen():
	$FileSelector.add_filter("*.json")

""" Called when the scene manager exit the scene """
func _pack_scene():
	# Use this to store some new keys into scene_parameters
	pass

func button_pressed(instructions, player_position, player_direction):
	print("Button '" + instructions + "' pressed !")
	if instructions == "select":
		$FileSelector.popup()
	elif instructions == "nb":
		var temp_node = ClassEncounter.new()
		temp_node.encounter_file = $LbZone.text
		temp_node.encounter_rate = int($EdRate.text)
		temp_node.encounter_dictionnary = DataRead.load_encounter_dictionnary($LbZone.text)
		dict_test_biomon = {}
		dict_test_biomon = {"None": 0}
		$LbResults.bbcode_text = "Calc for " + $EdNumbers.text + " steps with rate = " + $EdRate.text + "%"
		$LbResults.bbcode_text += "\n Expecting " + str(int($EdNumbers.text)* int($EdRate.text) /100) + " encounters with :"
		for key in temp_node.encounter_dictionnary.keys():
			$LbResults.bbcode_text += "\n-" + DataRead.database.biodex[key].name + ": " + str((int($EdNumbers.text)* int($EdRate.text) /100))
			dict_test_biomon[key] = 0
		for i in int($EdNumbers.text):
			temp_dict = temp_node.roll_encounter(true)
			if temp_dict == null:
				dict_test_biomon["None"] += 1
			else:
				dict_test_biomon[temp_dict["id"]] += 1
		

func _on_FileSelector_file_selected(path):
	$LbZone.text = path
