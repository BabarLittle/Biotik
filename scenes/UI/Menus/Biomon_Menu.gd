extends TextureButton

export(String) var text = "Text button"


func _ready():
	setup_text()
	hide_arrow()

func setup_text():
	$RichTextLabel.bbcode_text ="%s"%[text]

func show_arrows():
	for arrow in [$menu_arrow]:
		arrow.visible = true
		arrow.global_position.y = rect_global_position.y + (rect_size.y/2)
func hide_arrow():
	for arrow in [$menu_arrow]:
		arrow.visible = false


func _on_Button_Menu_focus_entered():
	 show_arrows()




func _on_Button_Menu_focus_exited():
	hide_arrow()




func _on_Button_Menu_mouse_entered():
	grab_focus()
