extends TextureButton

signal SignalMenuButtonPressed

export(String) var button_text = "Text button"
export(String, FILE) var button_target = ""

func _ready():
	setup_text()
	hide_arrow()

func setup_text():
	$RichTextLabel.bbcode_text ="%s"%[button_text]

func show_arrows():
	$menu_arrow.visible = true

func hide_arrow():
	$menu_arrow.visible = false

func _on_Button_Menu_pressed():
	emit_signal("SignalMenuButtonPressed", button_target)

func _on_Button_Menu_focus_entered():
	show_arrows()

func _on_Button_Menu_focus_exited():
	hide_arrow()

func _on_Button_Menu_mouse_entered():
	grab_focus()
