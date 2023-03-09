# meta-name: Annoted menu screen
# meta-description: Base template with complete annoted code for screen generation in Biotik
"""=============================================
File: biodex.gd
Author: Ska
Version: 0.3
Description:
	Controls and show the biodex 
	The sprites are controlled on this Script
	The names follow a signal and control themselves

Changes: 
	0.1 (Ska)
		- file creation
		- Name list
	0.1.2023.02.28 (Ska)
		- Sprite List
		- Other inputs
	0.2.2023.03.05 (Ska)
		- Updating the script with annotation and correct functions / signals to work with the 
		new scene manager and the new menu scene.
		- Adding the biodex_infos as a child instead of a fully independant scene.
	0.3.2023.03.07 (Ska)
		- Updating script with new class system

To-do: 
	- Eventually optimize both list scripts so we can move both with the same call and in the same way
	- Clean the code to take the biodex_infos inclusion into consideration
	- Switching between screens animations
============================================="""
extends ClassScreen

# Signals
signal SignalDexMove

# Misc
var dex_size = 0
var dex_current = 1
var dex_move_finished = true
var dict_direction = {
	"null": 0,
	"up": 1,
	"down": -1,
	"left": 10,
	"right": -10
}
var dex_direction = "null"
var count_stop = 0

var biodex_infos = "res://scenes/ui/screens/biodex/BiodexInfos.tscn"

""" Note : les différentes variables sont pas très dynamiques mais c'est + pour le nombre de biomons affichés..
le reste est facile à modifier """
# Name of the biomons
var biomon_list = [] # contains instances of biodex_listed.tscn
# Sprite, Position, biomon_id, is_moving
var sprite_list = [
	["", 0, 1, true],
	["", 1, 1, true],
	["", 2, 1, true],
	["", 3, 1, true],
	["", 4, 1, true],
]
var SPRITE_VALUES = {
	"position": [Vector2(25,-15), Vector2(20,0), Vector2(10,30), Vector2(20,90), Vector2(25,115)],
	"scale": [Vector2(0.2,0.2), Vector2(0.4,0.4), Vector2(0.8,0.8), Vector2(0.4,0.4), Vector2(0.2,0.2)] 
}
var SPRITE_NB = 5
var LIST_SCROLL_SPEED = 3
var LIST_SCALE = 0.4
var LIST_SCALE_FOCUS = 0.5
var LIST_Y_START = -10
var LIST_Y_INTERVAL = 15
var LIST_X_POS = 10
var LIST_X_POS_FOCUS = 0
var LIST_NB = 11 # nb of name at the same time in the list

"""=====
Function _unhandled_input()
Author: Ska
	input_handler to navigate through the biodex

====="""
func _unhandled_input(event):
	# Regular scrolling
	if dex_move_finished:
		if event.is_action_pressed("ui_down"):
			dex_direction = dict_direction["down"]
			dex_move_finished = false
		elif event.is_action_pressed("ui_right"):
			dex_direction = dict_direction["right"]
			dex_move_finished = false
		elif event.is_action_pressed("ui_up"):
			dex_direction = dict_direction["up"]
			dex_move_finished = false
		elif event.is_action_pressed("ui_left"):
			dex_direction = dict_direction["left"]
			dex_move_finished = false
		
		if !dex_move_finished:
			emit_signal("SignalDexMove", dex_direction, LIST_X_POS, LIST_Y_START, LIST_Y_INTERVAL, LIST_SCROLL_SPEED, LIST_SCALE_FOCUS-LIST_SCALE, LIST_NB)
			dex_current = DataRead.next_id(dex_current, -dex_direction, "biodex")
			side_bar_position()
			count_stop = 0
			$TimerScroll.start()
		# Select biomon and open the biodex_infos screen
		elif event.is_action_pressed("ui_accept"):
			print('click')
			dex_move_finished = false
			exit_scene(biodex_infos)

"""=====
Function load_scene
Author: Ska
	Function called when the scene manager is ready to make the scene appears. Loads all relevant 
	Data for the scene.

Arguments
	- inherited_parameters: dictionnary of parameters given by the last scene
====="""
func _load_screen():
	if "last_biomon_id" in scene_parameters.keys():
		dex_current = scene_parameters.last_biomon_id
	else: 
		dex_current = 1
	
	# Check number of biomon in the dex for the side bar
	dex_size = DataRead.get_biomon_numbers()
	
	""" Connecting signals """
	# Connect to timeout of child_node TimerScroll to be able to move the sprites
	$TimerScroll.connect("timeout", self, "move_sprites")
	
	""" load the lists of the biodex """
	load_lists()
	side_bar_position()
	
"""=====
Function exit_scene
Author: Ska
	Function called when the player exit the scene or exit one of the ui menu screens. 
	It save the variables needed for the next scene and then proceeds to signal the scene manager 
	it needs to switch scene.

Arguments
	- next_scene_path: mandatory path of the next scene
	- the others arguments are up to the needs of the scene
====="""
func _pack_scene():
	""" set the dictionnary to be sent to the next scene """
	scene_parameters.last_biomon_id = dex_current
	print('packing')


"""=====
Function load_list()
Author: Ska
	Function to redo / relocate
	Load all the biodex data

Arguments
	- next_scene_path: mandatory path of the next scene
	- the others arguments are up to the needs of the scene
====="""
func load_lists():
	""" Load the list of names """
	var scene_list = preload("res://scenes/ui/screens/Biodex/BiodexLabelList.tscn")
	
	var scene_scale = 1
	var x_pos_b = 1
	var y_pos_b = LIST_Y_START
	
	for i in range(0,LIST_NB):
		if i+1 == LIST_NB/2 + 1:
			x_pos_b = LIST_X_POS_FOCUS
			scene_scale = LIST_SCALE_FOCUS
		else:
			x_pos_b = LIST_X_POS
			scene_scale = LIST_SCALE
		biomon_list.append(scene_list.instance())
		connect("SignalDexMove", biomon_list[i], "move_name")
		$TimerScroll.connect("timeout", biomon_list[i], "moving_name")
		biomon_list[i].connect("SignalDexStop", self, "stop_count")
		$NameList.add_child(biomon_list[i])
		biomon_list[i].set_position(Vector2(x_pos_b, y_pos_b))
		biomon_list[i].set_scale(Vector2(scene_scale,scene_scale))
		
		biomon_list[i].load_id(dex_current, i+1, LIST_NB)
		y_pos_b += LIST_Y_INTERVAL
	
	""" Load the list of sprites """
	var scene_sprite = preload("res://scenes/ui/interface/BiomonBigSprite.tscn")
	var jump = 0
	for j in range(0,SPRITE_NB):
		sprite_list[j][0] = scene_sprite.instance()
		sprite_list[j][0].set_scale(SPRITE_VALUES["scale"][sprite_list[j][1]])
		sprite_list[j][0].set_position(SPRITE_VALUES["position"][sprite_list[j][1]]) 
		sprite_list[j][1] = j
		jump = j - (SPRITE_NB/2)
		sprite_list[j][2] = DataRead.next_id(dex_current, jump, "biodex")
		sprite_list[j][0].select_sprite(sprite_list[j][2])
		sprite_list[j][3] = true
		#connect("SignalDexMove", biomon_list[i], "moveName")
		$SpriteList.add_child(sprite_list[j][0])

""" Moves the sprites in the right direction + resize them + reposition them """
func move_sprites(scroll_direction = dex_direction):
	if !dex_move_finished:
		if abs(scroll_direction) == 1:
			for i in range(0,SPRITE_NB):
				# Si le sprite n'a pas fini de bouger
				if sprite_list[i][3]:
					# If the sprite is at the top edge while going up
					if sprite_list[i][1] == 0 and scroll_direction == -1:
						sprite_list[i][1] = sprite_list.size()-1
						sprite_list[i][2] = DataRead.next_id(sprite_list[i][2], (-scroll_direction)*sprite_list.size(), "biodex")
						sprite_list[i][0].select_sprite(sprite_list[i][2])
						sprite_list[i][3] = false
						sprite_list[i][0].position = SPRITE_VALUES["position"][sprite_list.size()-1]
						stop_count()
					# If the sprite is at the bottom edge while going down
					elif sprite_list[i][1] == sprite_list.size()-1 and scroll_direction == 1:
						sprite_list[i][1] = 0
						sprite_list[i][2] = DataRead.next_id(sprite_list[i][2], (-scroll_direction)*sprite_list.size(), "biodex")
						sprite_list[i][0].select_sprite(sprite_list[i][2])
						sprite_list[i][3] = false
						sprite_list[i][0].position = SPRITE_VALUES["position"][0]
						stop_count()
					# If the sprite is not on an edge
					else:
						# set variables
						var goal_x = (SPRITE_VALUES["position"][((sprite_list[i][1])+scroll_direction)][0])
						var goal_y = (SPRITE_VALUES["position"][((sprite_list[i][1])+scroll_direction)][1])
						var goal_scale = (SPRITE_VALUES["scale"][((sprite_list[i][1])+scroll_direction)][0])
						var direction_x = (goal_x - (SPRITE_VALUES["position"][(sprite_list[i][1])][0]))/5
						var direction_y = (goal_y - (SPRITE_VALUES["position"][(sprite_list[i][1])][1]))/5
						var direction_scale = (goal_scale - (SPRITE_VALUES["scale"][(sprite_list[i][1])][0]))/5
						
						#if sprite_list[i][0].position == SPRITE_VALUES["position"][((sprite_list[i][1])+(-scroll_direction))] and sprite_list[i][0].scale == SPRITE_VALUES["scale"][((sprite_list[i][1])+(-scroll_direction))]:
						if sprite_list[i][0].position == Vector2(goal_x, goal_y):
							sprite_list[i][1] += scroll_direction
							sprite_list[i][3] = false
							stop_count()
						else:
							sprite_list[i][0].set_position(Vector2(sprite_list[i][0].position.x+direction_x, sprite_list[i][0].position.y+direction_y))
							sprite_list[i][0].set_scale(Vector2(sprite_list[i][0].scale.x+direction_scale, sprite_list[i][0].scale.y+direction_scale))
		# if fast scroll
		elif abs(scroll_direction) == 10:
			for i in range(0,sprite_list.size()):
				sprite_list[i][2] = DataRead.next_id(sprite_list[i][2], (-scroll_direction), "biodex")
				sprite_list[i][0].select_sprite(sprite_list[i][2])
				stop_count()

func close_infos(new_current_id=dex_current):
	dex_current = new_current_id
	$biodex_infos.visible = false
	dex_move_finished = true

func stop_count():
	count_stop += 1
	if count_stop == LIST_NB + SPRITE_NB:
		$TimerScroll.stop()
		dex_move_finished = true
		for i in range(0,sprite_list.size()):
			sprite_list[i][3] = true
			
func side_bar_position():
	$NameList/SideBar.set_position(Vector2($NameList/SideBar.rect_position.x, (($NameList.rect_size.y-1.3*$NameList/SideBar.rect_size.y)/dex_size)*dex_current))
