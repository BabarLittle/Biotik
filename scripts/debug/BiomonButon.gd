extends TextureButton

const TEXTURE_PATH = "res://assets/characters/biomons/"

var focus_sprite
var biomon_infos
var biomon_obj: ClassBiomon

func load_buton(biomon_to_load = null):
	biomon_obj = biomon_to_load
	
	if biomon_obj == null:
		disabled = true
	else:
		disabled = false
		texture_hover.set_atlas(load(TEXTURE_PATH + biomon_obj.species))
		texture_focused.set_atlas(load(TEXTURE_PATH + biomon_obj.species))
		texture_normal.set_atlas(load(TEXTURE_PATH + biomon_obj.species))
		
	focus_sprite = get_node("%SpriteFocus")
	biomon_infos = get_node("%BiomonInfos")

func grab_sprite():
	var tween = get_tree().create_tween()
	focus_sprite.visible = true
	tween.tween_property(focus_sprite, "position", rect_position, 0.1)


func _on_BiomonButon_focus_entered():
	grab_sprite()
	biomon_infos.load_infos(biomon_obj)
	

func send_infos():
	pass


func _on_BiomonButon_focus_exited():
	focus_sprite.visible = false
