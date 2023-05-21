extends KinematicBody2D

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
onready var toolbox = $Toolbox
onready var torch = $Toolbox/TorchLight
onready var ray_cast = $Toolbox/InteractRayCast2D


enum PlayerState { 
	IDLE,  
	WALKING,
	RUNNING
	}

var intitial_position = Vector2(0,0)
var velocity = Vector2.ZERO
var last_known_direction = Vector2.DOWN

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
	toggle_torchlight(false)


func set_spawn(location: Vector2, direction: Vector2):
	anim_tree.set("parameters/Idle/blend_position", direction)
	anim_tree.set("parameters/Walk/blend_position", direction)
	anim_tree.set("parameters/Turn/blend_position", direction)
	last_known_direction = direction
	toolbox.turn(last_known_direction)
	position = location


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		is_moving = true
		last_known_direction = input_vector
		toolbox.turn(input_vector)
		
		#torch.rotation_degrees = rad2deg(input_vector.angle())
		anim_tree.set("parameters/Idle/blend_position", input_vector)
		anim_tree.set("parameters/Walk/blend_position", input_vector)
		anim_state.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta )
	else:
		anim_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		is_moving = false
		

	velocity = move_and_slide(velocity)
	
func get_player_direction():
	return last_known_direction

func toggle_torchlight(state=null):
	if !state == null:
		torch.enabled = state
	elif torch.enabled:
		torch.enabled = false
	else:
		torch.enabled = true

func _unhandled_input(event):
	if event.is_action_pressed("use_item"):
		toggle_torchlight()
		
	if event.is_action_pressed("interact"):
		scan_interact_target()

func set_control(mode):
	set_physics_process(mode)
	if !mode:
		anim_state.travel("Idle")

func scan_interact_target():
	var target = ray_cast.get_collider()
	print("Trying to interact with : " + str(target))
	if target != null:
		target._interact_action()
