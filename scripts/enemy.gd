extends Area2D

#FIREFLY
var list_action : Array[action_firefly]
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var time_between := 6000
var last_animation := Time.get_ticks_msec() + time_between
var rng : RandomNumberGenerator
var min_pos : Vector2
var max_pos : Vector2
var speed = 1
@export var go_up : bool = true

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	time_between = rng.randi_range(4000, 15000)

	if go_up:
		min_pos = Vector2(sprite_2d.position.x, sprite_2d.position.y - 2)
		max_pos = sprite_2d.position
		sprite_2d.position.y += rng.randi_range(-2, 0)
	else:
		min_pos = sprite_2d.position
		max_pos = Vector2(sprite_2d.position.x, sprite_2d.position.y + 2)
		sprite_2d.position.y += rng.randi_range(0, 2)
	
	
func _process(delta):
	for action in list_action:
		action.process_for_player(self)

func _physics_process(delta: float) -> void:
	if !sprite_2d.is_playing():
		if last_animation + time_between < Time.get_ticks_msec():
			last_animation = Time.get_ticks_msec()
			rng.randomize()
			time_between = rng.randi_range(7000, 20000)
			sprite_2d.play()
	
	if go_up:
		sprite_2d.position.y = clamp(sprite_2d.position.y - delta * speed, min_pos.y, max_pos.y)
		if(sprite_2d.position.y <= min_pos.y):
			go_up = false
	else:
		sprite_2d.position.y = clamp(sprite_2d.position.y + delta * speed, min_pos.y, max_pos.y)
		if(sprite_2d.position.y >= max_pos.y):
			go_up = true
func clean():
	for action in list_action:
		action.clean(self)
		list_action.erase(action)
