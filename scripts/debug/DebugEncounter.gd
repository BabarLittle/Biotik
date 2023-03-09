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

""" Called when the scene manager load the scene """
func _load_screen():
	$FileSelector.add_filter("*.json")
	$FileSelector.current_path = "res://data/encounters/"
	$LbZone.text = "res://data/encounters/01-grasspatchwest.json"

""" Called when the scene manager exit the scene """
func _pack_scene():
	# Use this to store some new keys into scene_parameters
	pass

func button_pressed(instructions, _player_position, _player_direction):
	print("Button '" + instructions + "' pressed !")
	$BiomonSprite.visible == false
	
	""" Choosing encounter file """
	if instructions == "select":
		$FileSelector.popup()
	
	# to first encounter
	elif instructions == "single":
		var count_steps = 0
		var temp_node = ClassEncounter.new()
		temp_node.encounter_file = $LbZone.text
		temp_node.encounter_rate = int($EdRate.text)
		temp_node.encounter_dictionnary = DataRead.load_encounter_dictionnary($LbZone.text)
		var temp_dict = null
		while temp_dict == null:
			temp_dict = temp_node.roll_encounter(true)
			count_steps += 1
		$LbResults.bbcode_text = "Encounters happenned after " + str(count_steps) + " !"
		$LbResults.bbcode_text += "\n A wild " + DataRead.database.biodex[temp_dict["id"]].name + " level " + str(temp_dict["level"]) + " appears !"
		$BiomonSprite.select_sprite(temp_dict["id"], true)
		$BiomonSprite.visible = true
	# Rolling multiple tests 
	elif instructions == "nb":
		var temp_node = ClassEncounter.new()
		var count_total_rate = 0
		temp_node.encounter_file = $LbZone.text
		temp_node.encounter_rate = int($EdRate.text)
		temp_node.encounter_dictionnary = DataRead.load_encounter_dictionnary($LbZone.text)
		var dict_test_biomon = {}
		dict_test_biomon = {"None": 0}
		$LbResults.bbcode_text = "Calc for " + $EdNumbers.text + " steps with rate = " + $EdRate.text + "%"
		$LbResults.bbcode_text += "\n Expecting " + str(float($EdNumbers.text)* (float($EdRate.text) /100)) + " encounters with :"
		# Count total rates
		for key in temp_node.encounter_dictionnary.keys():
			count_total_rate += temp_node.encounter_dictionnary[key].rate
		# Setting variables
		for key in temp_node.encounter_dictionnary.keys():
			$LbResults.bbcode_text += "\n-" + DataRead.database.biodex[key].name + ": " + str(((temp_node.encounter_dictionnary[key].rate / count_total_rate) * (float($EdRate.text))))
			dict_test_biomon[key] = 0
			
		var temp_dict = {}
		for i in int($EdNumbers.text):
			temp_dict = temp_node.roll_encounter(true)
			if temp_dict == null:
				dict_test_biomon["None"] += 1
			else:
				dict_test_biomon[temp_dict["id"]] += 1
		$LbResults.bbcode_text += "\n ======== \n Results : "
		for key in dict_test_biomon.keys():
			if key == "None":
				$LbResults.bbcode_text += "\n-No encounter : " + str(dict_test_biomon[key])
			else:
				$LbResults.bbcode_text += "\n-" +  DataRead.database.biodex[key].name + ": " + str(dict_test_biomon[key])

func _on_FileSelector_file_selected(path):
	$LbZone.text = path
