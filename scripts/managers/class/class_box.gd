extends Resource

class_name ClassBox

const BIOMONS_MAX = 20

var name: String = ''
var slots: Array = []

func _init(id) -> void:
	name = "New box " + str(id)
	for i in range(BIOMONS_MAX):
		slots.append(null)
	
func change_name(new_name:String = '') -> void:
	name = new_name

func add_biomon(new_biomon: ClassBiomon) -> bool:
	var i = 0 
	while (slots[i] != null) or (i > slots.size()-1):
		i += 1
	
	if slots[i] == null:
		slots[i] = new_biomon
		return true
	else:
		return false

func switch_biomon() -> void:
	pass
	
func release_biomon(target) -> void:
	slots[target] = null
