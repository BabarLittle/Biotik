# meta-name: Annoted menu screen
# meta-description: Base template with complete annoted code for screen generation in Biotik
"""=============================================
Main biodex. Points to the screen BiodexInfos.
============================================="""
extends ClassScreen

# Misc
var dex_current = 1

const scene_list_path = "res://scenes/ui/screens/Biodex/BiodexLabelList.tscn"
const biodex_infos_path = "res://scenes/ui/screens/biodex/BiodexInfos.tscn"

var NameListNode
var SpriteListNode
var SideBarNode
var InputManagerNode
var ScrollManagerNode


func _load_screen():
	if "last_biomon_id" in scene_parameters.keys():
		dex_current = scene_parameters.last_biomon_id
	else: 
		dex_current = 1

	InputManagerNode = $InputManager
	ScrollManagerNode =  $ScrollManager
	SpriteListNode = $Interface/SpriteList
	NameListNode = $Interface/NameList
	SideBarNode = $Interface/SideBar/SideBarPicture
	
	InputManagerNode.load_input_manager(ScrollManagerNode)
	ScrollManagerNode.load_scroll_manager(SpriteListNode, NameListNode, SideBarNode, dex_current)

func _pack_scene():
	""" set the dictionnary to be sent to the next scene """
	scene_parameters.last_biomon_id = ScrollManagerNode.get_current_biomon_id()
	print('packing')
