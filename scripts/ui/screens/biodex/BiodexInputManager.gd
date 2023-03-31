extends Node2D

const biodex_infos_path = "res://scenes/ui/screens/biodex/BiodexInfos.tscn"

var dict_direction = {
	"ui_up": -1,
	"ui_down": 1,
	"ui_left": -10,
	"ui_right": 10
}
var dex_direction = "null"
onready var ScrollManagerNode

func load_input_manager(scroll_manager):
	ScrollManagerNode = scroll_manager
	print("InputManager loaded")
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
			Utils.get_current_scene().exit_scene(biodex_infos_path)
			return
	
	if event.is_action_pressed("ui_down"):
		print("Input wants to scroll")
		ScrollManagerNode.scrolling_biodex(dict_direction["ui_down"])	
	if event.is_action_pressed("ui_up"):
		print("Input wants to scroll")
		ScrollManagerNode.scrolling_biodex(dict_direction["ui_up"])	
	if event.is_action_pressed("ui_left"):
		print("Input wants to scroll")
		ScrollManagerNode.scrolling_biodex(dict_direction["ui_left"])	
	if event.is_action_pressed("ui_right"):
		print("Input wants to scroll")
		ScrollManagerNode.scrolling_biodex(dict_direction["ui_right"])
