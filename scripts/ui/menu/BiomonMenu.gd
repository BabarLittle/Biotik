extends TextureButton

<<<<<<< Updated upstream
export(String) var text = "Text button"

=======
signal SignalMenuButtonPressed

export(String) var button_text = "Text button"
export(String, FILE) var button_target = ""
>>>>>>> Stashed changes

func _ready():
	setup_text()
	hide_arrow()

func setup_text():
<<<<<<< Updated upstream
	$RichTextLabel.bbcode_text ="%s"%[text]

func show_arrows():
	for arrow in [$menu_arrow]:
		arrow.visible = true
		arrow.global_position.y = rect_global_position.y + (rect_size.y/2)
func hide_arrow():
	for arrow in [$menu_arrow]:
		arrow.visible = false

<<<<<<< Updated upstream:scenes/UI/Menus/Biomon_Menu.gd
=======
=======
	$RichTextLabel.bbcode_text ="%s"%[button_text]

func show_arrows():
	$menu_arrow.visible = true

func hide_arrow():
	$menu_arrow.visible = false

>>>>>>> Stashed changes
func _on_Button_Menu_pressed():
	if button_target == "leave":
		get_tree().quit()
	else:
		emit_signal("SignalMenuButtonPressed", button_target)
<<<<<<< Updated upstream
>>>>>>> Stashed changes:scripts/ui/menu/BiomonMenu.gd

func _on_Button_Menu_focus_entered():
	 show_arrows()



=======

func _on_Button_Menu_focus_entered():
	show_arrows()
>>>>>>> Stashed changes

func _on_Button_Menu_focus_exited():
	hide_arrow()

<<<<<<< Updated upstream



=======
>>>>>>> Stashed changes
func _on_Button_Menu_mouse_entered():
	grab_focus()
