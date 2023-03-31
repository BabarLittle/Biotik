extends Node2D

signal SignalSceneChanging

var scene_parameters = {}



func exit_scene(next_scene_path, spawn_location, spawn_direction):
	scene_parameters.spawn_location = spawn_location
	scene_parameters.spawn_direction = spawn_direction

	emit_signal("SignalSceneChanging", next_scene_path)
