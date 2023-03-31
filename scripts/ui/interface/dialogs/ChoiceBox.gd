extends NinePatchRect

var choice_box_type = "OUI_NON"

func _ready():
	visible = false

func load_choice_box(choice_type = "OUI_NON"):
	connect_children()
	
	choice_box_type = choice_type
	
	match choice_type:
		"OUI_NON":
			$VBoxContainer/Choice1.setup_text("Oui")
			$VBoxContainer/Choice1.grab_focus()
			$VBoxContainer/Choice2.setup_text("Non")
			visible = true

func connect_children():
	$VBoxContainer/Choice1.connect("SignalMenuButtonPressed", get_parent(), "choice_box_return")
	$VBoxContainer/Choice2.connect("SignalMenuButtonPressed", get_parent(), "choice_box_return")
