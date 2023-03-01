extends Node2D

signal DexStop

export var biomon_id = 1

var is_moving = false
var scroll_goal = Vector2.ZERO
var SCROLL_DIRECTION = 0
var current_position = 0 # current id

var list_y_start_b = -10
var list_y_interval_b = 15
var list_nb_b = 11 #Nb of name at the same time in the list
var scale_goal = 0.1
var scroll_speed_b = 3
var scroll_speed_x = 2

func load_id(id=1, list_position=0, nb=11):
	var id_to_load = 0
	var list_offset = 0
	
	list_offset = list_position-(nb/2+1)
	id_to_load = DataRead.next_id(id, list_offset, "biodex")

	$state.frame = RandomNumberGenerator.new().randi_range(0,3)
	$text.text = str(id_to_load) + " " + DataRead.biodex[str(id_to_load)].name
	biomon_id = id_to_load

func move_name(scroll_direction=0, LIST_X_POS=10, LIST_Y_START=-10, LIST_Y_INTERVAL=15, LIST_SCROLL_SPEED=3, SCALE_DIFF=0.1, LIST_NB=11):
	scroll_speed_b = LIST_SCROLL_SPEED * scroll_direction
	list_y_start_b = LIST_Y_START
	list_y_interval_b = LIST_Y_INTERVAL
	list_nb_b = LIST_NB
	SCROLL_DIRECTION = scroll_direction
	
	if !is_moving:
		if abs(SCROLL_DIRECTION) == 1:
			check_position()
				
			if ((position.y-LIST_Y_START) / LIST_Y_INTERVAL)+1 == 6 - scroll_direction and scroll_direction != 0:
				scroll_goal = Vector2(0, position.y + scroll_direction*LIST_Y_INTERVAL)
				scale_goal = SCALE_DIFF
				scroll_speed_x = -abs((scroll_speed_b /3) *2)
			else:
				scroll_goal = Vector2(LIST_X_POS, position.y + scroll_direction*LIST_Y_INTERVAL)
				if ((position.y-LIST_Y_START) / LIST_Y_INTERVAL)+1 == 6:
					scale_goal = -SCALE_DIFF
					scroll_speed_x = abs((scroll_speed_b /3) *2)
				else:
					scale_goal = 0
					scroll_speed_x = 0
		is_moving = true
	

func moving_name():
	if is_moving:
		if abs(SCROLL_DIRECTION) == 1:
			if position == scroll_goal:
				is_moving = false
				emit_signal("DexStop")
			else:
				if position.x != scroll_goal[0] and position.y != scroll_goal[1]:
					set_position(Vector2(position.x+scroll_speed_x, position.y+scroll_speed_b))
				elif position.x != scroll_goal[0]:
					set_position(Vector2(position.x+scroll_speed_x, position.y))
				elif position.y != scroll_goal[1]:
					set_position(Vector2(position.x, position.y+scroll_speed_b))
				
			if scale_goal != 0 and scroll_speed_b != 0:
				scale_goal -= 0.02 *(abs(scale_goal)/scale_goal)
				set_scale(Vector2(scale[0]+(0.02*(abs(scale_goal)/scale_goal)), scale[1]+(0.02*(abs(scale_goal)/scale_goal))))
		elif abs(SCROLL_DIRECTION) == 10:
			is_moving = false
			print("OKAY")
			emit_signal("DexStop")
			biomon_id = DataRead.next_id(biomon_id, -SCROLL_DIRECTION, "biodex")
			$state.frame = RandomNumberGenerator.new().randi_range(0,3)
			$text.text = str(biomon_id) + " " + DataRead.biodex[str(biomon_id)].name
			
			

""" Function check_position check if the scene is out of bound and need to replace itself """
func check_position():
	# too low -> we go at the top and switch id accordingly
	if position.y >= (list_y_start_b + list_nb_b * list_y_interval_b):
		set_position(Vector2(10, position.y-list_y_interval_b*list_nb_b))
		biomon_id = DataRead.next_id(biomon_id, -list_nb_b, "biodex")
		
	# too high -> we go at the bottom and switch id accordingly
	elif position.y <= list_y_start_b:
		set_position(Vector2(10, position.y+list_y_interval_b*list_nb_b))
		biomon_id = DataRead.next_id(biomon_id, list_nb_b, "biodex")
		
	# changing the label accordingly
	$state.frame = RandomNumberGenerator.new().randi_range(0,3)
	$text.text = str(biomon_id) + " " + DataRead.biodex[str(biomon_id)].name
	
