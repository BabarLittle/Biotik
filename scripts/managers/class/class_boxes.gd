extends Resource

class_name ClassBoxes

const MIN = 4
const MAX = 10

var boxes = []
var current setget set_current, get_current

func _init():
	for i in range(MIN):
		boxes.append(ClassBox.new())
	current = 0

func get_box(id: int = 0):
	if id in range(boxes.size()):
		return boxes[id]
	else:
		return null

func new_box(first = null):
	boxes.append(ClassBox.new())
	boxes[-1].add_biomon(first)
	return boxes.size()-1

func set_current(value):
	if value in range(boxes.size()-1):
		current = value

func get_current():
	return boxes[current]

func add_biomon(new_biomon):
	var start = current
	var breaking = false
	while boxes[current].add_biomon(new_biomon):
		current += 1
		if current >= boxes.size():
			current = 0
			if !breaking:
				breaking = true
		if current == start and breaking:
			current = new_box(new_biomon)
			break

func release_biomon(position = null):
	if position != null:
		boxes[position.x].release_biomon(position.y)
