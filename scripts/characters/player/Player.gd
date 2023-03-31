extends KinematicBody2D

signal player_moving_signal
signal player_stopped_signal
signal player_entering_door_signal
signal player_entered_door_signal



export var walk_speed = 4.0
export var jump_speed = 4.0

const TILE_SIZE = 16
const landing_dust = preload("res://scenes/environnement/effects/LandingDustEffect.tscn")

# Max speed reachable, acceleratio = to reach the speed, friction = to reach stand still from movement

const MAX_SPEED = 60
const ACCELERATION = 500
const FRICTION = 500

onready var  animationplayer = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")


onready var shadow = $Shadow


enum PlayerState { 
	IDLE,  
	WALKING,
	RUNNING
	}

var intitial_position = Vector2(0,0)
var velocity = Vector2.ZERO

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
	var input_vector = Vector2.ZERO
	
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		is_moving = true
		anim_tree.set("parameters/Idle/blend_position", input_vector)
		anim_tree.set("parameters/Walk/blend_position", input_vector)
		anim_state.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta )
	else:
		anim_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		is_moving = false
		

	velocity = move_and_slide(velocity)
	
	
	


