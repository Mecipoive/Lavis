extends CharacterBody2D

class_name Player 

@export var ghost_dash : PackedScene
@export var invert_ghost_dash : PackedScene
@export var is_flip = false

@onready var ghost_timer: Timer = $Ghost_timer
@onready var animated_sprite_invert: AnimatedSprite2D = %AnimatedSprite2D_invert
@onready var animated_sprite: AnimatedSprite2D = $%AnimatedSprite2D
@onready var test: Label = $Label

var timer_dash : SceneTreeTimer

#HORIZONTAL MOVEMENT
const SPEED = 150.0
const ACCELERATION = 1200.0
const FRICTION = 1400.0
const MAX_SPEED = 250.0

# VERTICAL MOVEMENT
var GRAVITY = 1000.0
var FALL_GRAVITY = 1000.0
var FAST_FALL_GRAVITY = 5000.0
var JUMP_VELOCITY = -300.0

#INPUT BUFFER / COYOTE

const INPUT_BUFFER_PATIENCE = 0.1
const COYOTE_TIME = 0.08

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true

#SPRITES DIRECTION
var is_facing_right : bool = true

#STOP MOVEMENT
var can_move =  false

#DASH
var can_dash: bool = true
var dash_direction = Vector2 (1,0)
var dashing = false
const time_between_color_swap := 200
var last_color_swap := Time.get_ticks_msec() + time_between_color_swap
#SOUND
var was_on_floor = true
var dash_speed := 300

#FIREFLY
var list_action : Array[action_firefly]

@onready var stoppeurs = get_tree().get_nodes_in_group("Stoppeur")

func _ready() -> void:
	animated_sprite.flip_v = is_flip
	animated_sprite_invert.flip_v = is_flip
	for i in stoppeurs:
		i.cannot_move.connect(state_change)
	
	# Setup input buffer timer
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)
	# Setup coyote timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	
	coyote_timer.timeout.connect(coyote_timeout)

func _physics_process(delta: float) -> void:
	#test.text = str(velocity.y)
	
	var horizontal_input = Input.get_axis("left","right")
	var jump_attempted = Input.is_action_just_pressed("jump")
	
	
	
	# Animations
	if touch_with_feet():
		if horizontal_input != 0:
			animated_sprite.play("Run")
			animated_sprite_invert.play("Run")
		else:
			animated_sprite.play("Idle")
			animated_sprite_invert.play("Idle")
	else:
		if !dashing:
			animated_sprite.play("Fall")
			animated_sprite_invert.play("Fall")
		else:
			animated_sprite.play("Dash")
			animated_sprite_invert.play("Dash")
	
	if can_move == true:
		
		dash()
		# vertical inputs
		if jump_attempted or input_buffer.time_left > 0:
			if coyote_jump_available:
				velocity.y = JUMP_VELOCITY
				coyote_jump_available = false
			elif jump_attempted:
				input_buffer.start()
		
		if Input.is_action_just_released("jump") and velocity.y * sign(GRAVITY) < 0 and !dashing:
			velocity.y = JUMP_VELOCITY / 4
		
		if touch_with_feet():
			coyote_jump_available = true
			coyote_timer.stop()
		else:
			if coyote_jump_available:
				if coyote_timer.is_stopped():
					coyote_timer.start()
			velocity.y = clamp(velocity.y + _get_gravity(horizontal_input) * delta, -MAX_SPEED, MAX_SPEED)
			
		# horizontal inputs
		var floor_damping : float = 1.0 if touch_with_feet() else 0.2
		if !dashing:
			if horizontal_input:
				velocity.x = move_toward(velocity.x, horizontal_input * SPEED, ACCELERATION * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, (FRICTION * delta) * floor_damping)
				
		if is_on_floor() and velocity.x != 0:
			SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.WALK)
		

		for action in list_action:
			action.process_for_player(self)
		move_and_slide()

		
	if not was_on_floor and touch_with_feet():
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.LAND)
		
	was_on_floor = touch_with_feet()


	 # Change player direction using flip_h
	if horizontal_input > 0 and !is_facing_right:
		is_facing_right = true
		animated_sprite.flip_h = false  # Face right
		animated_sprite_invert.flip_h = false
	elif horizontal_input < 0 and is_facing_right:
		is_facing_right = false
		animated_sprite.flip_h = true  # Face left
		animated_sprite_invert.flip_h = true

func clean():
	for action in list_action:
		action.clean(self)
		list_action.erase(action)

func touch_with_feet():
	if GRAVITY > 0:
		return is_on_floor()
	else:
		return is_on_ceiling()

func _get_gravity(input_dir : float = 0) -> float:
	if Input.is_action_just_pressed("down"):
		return FAST_FALL_GRAVITY
	if dashing:
		return 0
	return GRAVITY if velocity.y * sign(GRAVITY) < 0 else FALL_GRAVITY


func coyote_timeout():
	coyote_jump_available = false


func state_change(b : bool):
	can_move = b

func _process(delta: float) -> void:
	
	if !can_dash and last_color_swap + time_between_color_swap < Time.get_ticks_msec():
		visible = !visible
		last_color_swap = Time.get_ticks_msec()
	elif can_dash and !visible and can_move and !touch_with_feet():
		visible = true
func dash():
	
	if touch_with_feet():
		visible = true
		can_dash = true

	dash_direction = Vector2(Input.get_axis("left","right"), Input.get_axis("up","down"))

	if Input.is_action_just_pressed("dash") and can_dash:
		SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.DASH)
		if dash_direction == Vector2.ZERO:
			dash_direction = Vector2(0,-1) * sign(GRAVITY)
		velocity = dash_direction.normalized() * dash_speed
		can_dash = false
		dashing = true
		ghost_timer.start()
		timer_dash = get_tree().create_timer(0.2)
		await timer_dash.timeout
		timer_dash = null
		ghost_timer.stop()
		dashing = false
		velocity = velocity / 4

func add_ghost():
	var invert_ghost = invert_ghost_dash.instantiate()
	var ghost = ghost_dash.instantiate()
	invert_ghost.set_property(global_position, $AnimatedSprite2D.scale)
	ghost.set_property(global_position, $AnimatedSprite2D.scale)
	get_tree().current_scene.add_child(invert_ghost)
	get_tree().current_scene.add_child(ghost)


func _on_ghost_timer_timeout() -> void:
	add_ghost()
