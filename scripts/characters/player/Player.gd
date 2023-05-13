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
onready var torch = $TorchLight
onready var ray_cast = $InteractRayCast2D


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
	position = location


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		is_moving = true
		last_known_direction = input_vector
		turn_objects(input_vector)
		
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

func turn_objects(new_angle):
	# Torch
	var old_rotation = torch.rotation_degrees
	var new_rotation = rad2deg(new_angle.angle())
	var rotating_value = fix_torch_rotation(new_rotation - old_rotation)
	
	$Tween.interpolate_property(torch, "rotation_degrees",
		old_rotation, old_rotation+rotating_value, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	ray_cast.rotation_degrees = new_rotation

func fix_torch_rotation(angle):
	if abs(angle) > 180:
		angle = wrapi(angle -360,-180,180)
	return angle

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
