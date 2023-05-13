extends CanvasModulate

class_name ClassAmbientLight

var is_pro_active = false
export (Color) var _fluctuations
var tween

func _ready():
	#visible = false
	pass
	
func load_ambient_light(is_self_efficient):
	is_pro_active = is_self_efficient
	if !is_pro_active:
		Utils.get_game_timer().connect_to_timer(self)
		color = Utils.get_game_timer().light_state()
		
	_specific_load()
	
func update_ambient_light(new_ambient_color, speed, transition_color=null):
	if transition_color == null:
		transition_color = color
	
	tween = create_tween()
	tween.set_parallel(false)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	if is_pro_active:
		tween.tween_property(self, "color", transition_color, speed/2).from(color)
		tween.tween_property(self, "color", new_ambient_color, speed/2).from(transition_color)
	else:
		tween.tween_property(self, "color", transition_color, speed/2).from(color)
		tween.tween_property(self, "color", new_ambient_color, speed/2).from(transition_color)
		
func _specific_load():
	pass
