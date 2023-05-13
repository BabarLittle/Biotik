extends TextureButton

signal SignalChoiceButtonPressed

export(String) var button_text = "Text button"
export(String) var button_key = ""
export(bool) var first_choice = false
export(String, FILE) var pressed_sound = "res://assets/audio/sfx/013_Confirm_03.wav"
export(String, FILE) var focus_sound = "res://assets/audio/sfx/001_Hover_01.wav"

func load_button(text_to_add = button_text, focus_on = first_choice, new_key = button_key):
	button_text = text_to_add
	$ChoiceText.text = text_to_add
	button_key = new_key
	if focus_on:
		grab_focus()

func show_arrows():
	$menu_arrow.visible = true

func hide_arrow():
	$menu_arrow.visible = false

func _on_Button_Menu_pressed():
	play_sfx(pressed_sound)
	emit_signal("SignalChoiceButtonPressed", button_key)

func _on_Button_Menu_focus_exited():
	pass

func _on_Button_Menu_focus_entered():
	play_sfx(focus_sound)
	
func play_sfx(sfx_path):
	$btSound.stream = load(sfx_path)
	$btSound.play()

func get_size():
	return 10 + $ChoiceText.text.length() * 4
