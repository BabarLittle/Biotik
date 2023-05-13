extends KinematicBody2D

export (String, FILE) var npc_sprite_texture
export (String) var npc_name = "Inconnu"
export (bool) var floating_text_active = false
export (String) var floating_text = "Je me demande ..."

onready var name_text = get_node("LbName")
onready var action_text = get_node("LbAction")
onready var dialogue_detection = get_node("DialogueDetection")
onready var sprite = get_node("Sprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_text.visible = false
	name_text.text = npc_name
	action_text.visible = false
	refresh_dialogue_detection()
	set_sprite_texture()
	
	
func refresh_dialogue_detection(new_state=null):
	if new_state != null:
		floating_text_active = new_state
		
	dialogue_detection.set_state(floating_text_active)

func _interact_action():
	pass
	
func set_sprite_texture(new_texture = npc_sprite_texture):
	var temp_file = File.new()
	
	if !temp_file.file_exists(new_texture):
		return
		
	if npc_sprite_texture != sprite.texture:
		sprite.texture = load(new_texture)
