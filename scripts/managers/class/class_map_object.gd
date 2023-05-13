extends StaticBody2D

class_name ClassMapObject

enum EncounterZone {NONE=0, GROUND=1, WATER=2, TREE=3, FISHING=4}

export (String, FILE) var sound_file
export (EncounterZone) var encounter_zone = EncounterZone.NONE
export (bool) var encounter_on_touch = false
export (bool) var night_time_light = false
export (bool) var lights_on = false
export (bool) var lights_flicker = false

var object_sprite
var object_sound
var object_area
var object_lights
var player_body_name
var player_inside

func set_parameters(frame_id, global_position):
	object_sprite = get_node_or_null("Sprite")
	object_sound = get_node_or_null("SfxPlayer")
	object_area = get_node_or_null("Area2D")
	object_lights = get_node_or_null("Lights")
	player_body_name = Utils.get_player().name
	
	object_sprite.frame = int(frame_id)
	position = global_position - get_sprite_offset()
	if sound_file != "":
		object_sound.stream = load(sound_file)
		
	if object_lights != null:
		if night_time_light:
			Utils.get_game_timer().connect_to_timer(self)
		_control_lights(lights_on)
	
	_specifics_parameters()

func _ready():
	object_sprite = get_node("Sprite")
	object_sound = get_node("SfxPlayer")
	object_area = get_node("Area2D")
	
	object_area.connect("body_entered", self, "_on_Area2D_body_entered")	
	object_area.connect("body_exited", self, "_on_Area2D_body_exited")	
	set_collision_layer_bit(1, true)

func _on_Area2D_body_entered(body):
	if body.name == player_body_name:
		player_inside = true
	
	_body_entered_script(body)
	
	if encounter_on_touch and player_inside:
		roll_encounter()
	
func _on_Area2D_body_exited(body):
	_body_exited_script(body)
	
	if body.name == player_body_name:
		player_inside = false

func get_sprite_offset():
	return object_sprite.offset + object_sprite.position

func roll_encounter():
	if encounter_zone != EncounterZone.NONE: 
		Utils.get_current_scene().check_encounter(encounter_zone)
		
func _body_entered_script(_body):
	pass

func _body_exited_script(_body):
	pass
	
func _interact_action():
	pass
	
func _specifics_parameters():
	pass

func update_ambient_light(_arg0, _arg1, _arg2):
	if Utils.get_game_timer().sunlight_state == 0:
		_control_lights(false)
	else:
		_control_lights(true, lights_flicker)
	
func _control_lights(state, flicker = false):
	if object_lights != null:
		for child in object_lights.get_children():
			if flicker:
				random_flickering(child, state)
			else:
				child.enabled = state
			
func random_flickering(light, state):
	var temp_tween = get_tree().create_tween()
	var random_int = RandomNumberGenerator.new()
	random_int.randomize()
	
	if random_int.randi_range(0,99) < 100 and state:
		var nb_flickering = random_int.randi_range(2, 7)
		var temp_bool = !state
		print(light.name + " flickers " + str(nb_flickering)+ " times !")
		for _i in range(0,nb_flickering):
			temp_tween.tween_property(light, "enabled", temp_bool, random_int.randf_range(0.1, 2.0))
			temp_bool = !temp_bool
	
	temp_tween.tween_property(light, "enabled", state, 0.1)
	
	
