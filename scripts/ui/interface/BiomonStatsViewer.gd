# meta-name: Annoted biotik
# meta-description: Base template with complete annoted code for scene generation in Biotik
"""=============================================
File: BiomonStatsViewer
Author: Ska
Version: 0.1
Description:
	(...)

Changes: 
	0.1
		- file creation

To-do: 
	-(...)
============================================="""

extends Node2D

# Set up signals

# Set up constants

# Set up variables
export (Color, RGBA) var color_shape = Color8(216, 208, 216, 255)
export (Color, RGBA) var color_stats = Color8(137, 41, 137, 193)
export (Color, RGBA) var color_line = Color8(245, 245, 245, 255)
export (Color, RGBA) var color_font = Color8(245, 245, 245, 255)
onready var dictionary_line = {
	"hp": {"label": $StatsBox/HpLine/HpNb, "line": $StatsBox/HpLine, "order": 1},
	"att": {"label": $StatsBox/AttLine/AttNb, "line": $StatsBox/AttLine, "order": 2},
	"def": {"label": $StatsBox/DefLine/DefNb, "line": $StatsBox/DefLine, "order": 3},
	"spa": {"label": $StatsBox/SpaLine/SpaNb, "line": $StatsBox/SpaLine, "order": 4},
	"spd": {"label": $StatsBox/SpdLine/SpdNb, "line": $StatsBox/SpdLine, "order": 5},
	"vit": {"label": $StatsBox/SpeLine/SpeNb, "line": $StatsBox/SpeLine, "order": 6}
	}

# Temps variables for testing
var stats_dictionnary = {"hp": 14, "att": 104, "def": 67, "vit": 120, "spd": 70, "spa": 82}

func _ready():
	set_box_colors(color_stats, color_shape, color_line, color_font)
	print($StatsBox/StatsPolygon.get_polygon())
	load_biomon_stats(stats_dictionnary)

"""=====
Function load_biomon_stats
Author: Ska
	Load the stats in the StatsPolygon shape out of a dictionnary of values

Arguments
	- values: stats to load
	- base_stats : if true, changes the scaling of values
====="""
func load_biomon_stats(values: Dictionary = {}, base_stats=false):
	""" Testing dictionary values """
	if values == {} or values == null:
		print("WAR: No stats provided")
		pass
	else:
		for key in values.keys():
			if typeof(values[key]) != TYPE_INT:
				values[key] = 0
	
	""" Setting the scale """
	var max_value
	if base_stats:
		max_value = 150
	else:
		max_value = 300
		
	""" main body """
	var new_polygon_values = [Vector2.ZERO]
	for key in values.keys():
		dictionary_line[key].label.text = str(values[key])
		new_polygon_values.append(get_point_position(values[key], dictionary_line[key], max_value))
	new_polygon_values.append(new_polygon_values[1])
	
	""" Animate stats changing """
	var steps : int = 5 # amount of interpolation steps
	var refreshrate : float = 0.01-0.1 #time between each step
	for _i in range(steps):
		for pt in new_polygon_values.size():
			var way = new_polygon_values[pt] - $StatsBox/StatsPolygon.polygon[pt]
			$StatsBox/StatsPolygon.polygon[pt] += way.normalized() * (way.length() / steps )
		yield(get_tree().create_timer(refreshrate),"timeout")


"""=====
Function set_box_colors
Author: Ska
	Changes color. Allows different color palettes for different scenes

Arguments
	- differents colors for the differents parts of the StatsBox
====="""
func set_box_colors(new_color_stats, new_color_shape, new_color_line, new_color_font):
	for child in $StatsBox.get_children():
		if "Line" in child.name:
			child.modulate = new_color_line
			if child.get_child_count() > 0:
				for grand_child in child.get_children():
					if "b" in grand_child.name:
						grand_child.set("custom_colors/font_color", new_color_font)
		elif "Stats" in child.name:
			child.color = new_color_stats
		else:
			child.color = new_color_shape
			
""" Basic math to take new Vector2 coordinate """
func get_point_position(new_stat=10, selected_stat={}, max_value=150):
	var line_position = selected_stat.line.get_points()[0]
	var length_line = sqrt(pow(line_position.x,2) + pow(line_position.y,2))
	var new_length = new_stat * scale
	
	var new_vector2 = line_position.normalized() * new_stat * (length_line/max_value) 
	return new_vector2
