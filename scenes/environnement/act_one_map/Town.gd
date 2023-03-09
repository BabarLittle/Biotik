extends Node2D

signal Signal_SceneChanging

var scene_parameters = {}



func exit_scene(next_scene_path, spawn_location, spawn_direction):
	scene_parameters.spawn_location = spawn_location
	scene_parameters.spawn_direction = spawn_direction

	emit_signal("Signal_SceneChanging", next_scene_path)
