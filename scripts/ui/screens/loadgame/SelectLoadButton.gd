extends TextureButton

# Set up signals
signal SignalButtonGamePressed # Mandatory to communicate with scene manager through the menu scene

# Set up constants
const FOCUS_SCALE = Vector2(0.1,0.1)
const SCALING_TIME = 0.1
var base_scale


# Set up variables
export var game_id: int = 0
export(bool) var first_button = false
var just_pressed = false

func _ready():
	assert(connect("SignalButtonGamePressed", get_parent().get_parent(), "load_selected_game") == 0, self.name + " failed to connect to '" + get_parent().get_parent().name)
	base_scale = rect_scale
	just_pressed = false
	if first_button:
		grab_focus()
	
func set_button_informations(game_informations):
	if typeof(game_informations) == TYPE_DICTIONARY:
		$EmptySlot.visible = false
		$lbName.text = game_informations.informations.player_name
		$lbTitle.text = game_informations.informations.player_title
		$lbTime.text = game_informations.informations.time_played
		$lbLocation.text = game_informations.informations.current_scene_name
		$lbVus.text = str(game_informations.informations.biomons_seen)
		$lbPris.text = str(game_informations.informations.biomons_captured)
		$Picture.texture = load(game_informations.informations.picture_path)
		for i in range(game_informations.informations.badges.size()-1):
			if game_informations.informations.badges[i] >= 1:
				$Badges.get_child(i).frame = 0
			else:
				$Badges.get_child(i).frame = 1
	elif game_informations == "empty":
		$EmptySlot.visible = true

func _on_TextureButton_pressed():
	just_pressed = true
	emit_signal("SignalButtonGamePressed", game_id)
	$AudioStreamPlayer.stream = load("res://assets/audio/sfx/013_Confirm_03.wav")
	$AudioStreamPlayer.play()


func _on_TextureButton_focus_entered():
	if !first_button:
		$AudioStreamPlayer.stream = load("res://assets/audio/sfx/001_Hover_01.wav")
		$AudioStreamPlayer.play()
	else:
		first_button = false
	$Tween.interpolate_property(self, "rect_scale",
		self.rect_scale, base_scale+FOCUS_SCALE, SCALING_TIME,
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_TextureButton_focus_exited():
	if !just_pressed:
		$Tween.interpolate_property(self, "rect_scale",
			self.rect_scale, base_scale, SCALING_TIME,
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		$Tween.start()
