extends KinematicBody2D

signal player_moving_signal
signal player_stopped_signal
signal player_entering_door_signal
signal player_entered_door_signal
#signal player_entering_area


export var walk_speed = 4.0
export var jump_speed = 4.0

const TILE_SIZE = 16
const landing_dust = preload("res://scenes/environnement/effects/LandingDustEffect.tscn")


onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var ray = $BlockingRayCast2D
onready var ledge_ray = $LedgeRayCast2D
onready var shadow = $Shadow
onready var door_ray = $DoorRayCast2D

enum PlayerState { IDLE, TURNING, WALKING}
enum FacingDirection { LEFT, RIGHT, UP, DOWN}

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

var intitial_position = Vector2(0,0)
var input_direction = Vector2(0,0)

var is_moving = false
var stop_input : bool = false
var jumping_over_ledge: bool = false
var percent_moved_to_next_tile = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.visible = true
	anim_tree.active = true
	intitial_position = position
	shadow.visible = false


func set_spawn(location: Vector2, direction: Vector2):
	anim_tree.set("parameters/Idle/blend_position", direction)
	anim_tree.set("parameters/Walk/blend_position", direction)
	anim_tree.set("parameters/Turn/blend_position", direction)
	position = location

func _physics_process(delta):
	if player_state == PlayerState.TURNING or stop_input:
		return
	if is_moving == false or Utils.get_scene_manager().screen_loaded != Utils.get_scene_manager().ScreenLoaded.SCENE:
		process_player_movement_input()
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		is_moving = false

func process_player_movement_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_tree.set("parameters/Turn/blend_position", input_direction)
		
		if need_to_turn():
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			intitial_position = position
			is_moving = true
	else:
		anim_state.travel("Idle")
		
func need_to_turn():
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif input_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif input_direction.y < 0:
		new_facing_direction = FacingDirection.UP
	elif input_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN
		
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	facing_direction = new_facing_direction
	return false

func finished_turning():
	player_state = PlayerState.IDLE
	
func entered_door():
	#Probleme des aire qui tp vers zone 1 vienne d'ici
	print("Player entered_door() and emits 'player_entered_door_signal")
	emit_signal("player_entered_door_signal")

func move(delta):
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	 
	ray.cast_to = desired_step
	ray.force_raycast_update()
	
	ledge_ray.cast_to = desired_step
	ledge_ray.force_raycast_update()
	
	door_ray.cast_to = desired_step
	door_ray.force_raycast_update()
	
	if door_ray.is_colliding():
<<<<<<< Updated upstream
<<<<<<< Updated upstream:scenes/characters/player/Player.gd
		var object = door_ray.get_collider()
		if percent_moved_to_next_tile == 0.0:
=======
=======
>>>>>>> Stashed changes
		print(percent_moved_to_next_tile)
		if abs(percent_moved_to_next_tile / (walk_speed * delta)) == 2:
			door_ray.get_collider().target_door = true
			print("Player door_ray is colliding with something, emiting signal")
<<<<<<< Updated upstream
>>>>>>> Stashed changes:scripts/characters/player/Player.gd
=======
>>>>>>> Stashed changes
			emit_signal("player_entering_door_signal")
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = intitial_position + (input_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			anim_state.travel("Idle")
			stop_input = true
			$AnimationPlayer.play("Disapear")
			$Camera2D.clear_current()
			
		else:
			position = intitial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)

	
	elif (ledge_ray.is_colliding())  and input_direction == Vector2(0,1)or jumping_over_ledge:
		percent_moved_to_next_tile += jump_speed * delta
		if percent_moved_to_next_tile >= 2.0:
			position = intitial_position + (input_direction * TILE_SIZE *2)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			jumping_over_ledge = false
			shadow.visible = false
			
			var dust_effect = landing_dust.instance()
			dust_effect.position = position
			get_tree().current_scene.add_child(dust_effect)
		else:
			shadow.visible = true
			jumping_over_ledge = true
			var input = input_direction.y * TILE_SIZE *percent_moved_to_next_tile
			position.y = intitial_position.y  + (0.96 - 0.55 * input + 0.05 * pow(input, 2))

	
	elif !ray.is_colliding():
		if percent_moved_to_next_tile == 0:
			emit_signal("player_moving_signal")
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = intitial_position + (TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			emit_signal("player_stopped_signal")
		else:
			position = intitial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile )
	else:
		is_moving = false
