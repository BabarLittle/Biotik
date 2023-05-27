extends TextureButton

var focus_sprite
var biomon_infos
var biomon_dict: ClassBiomon

func load_buton(biomon_to_load = null):
	biomon_dict = biomon_to_load
	
	if biomon_dict == null:
		disabled = true
	else:
		pass
		
	focus_sprite = get_node("%SpriteFocus")
	biomon_infos = get_node("%BiomonInfos")

func grab_sprite():
	var tween = get_tree().create_tween()
	tween.tween_property(focus_sprite, "position", rect_position, 0.1)

func _on_BiomonButon_focus_entered():
	grab_sprite()
	biomon_infos.load_infos(biomon_dict)
	
func send_infos():
	pass
