extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var time_between := 6000
var last_animation := Time.get_ticks_msec() + time_between
var rng : RandomNumberGenerator
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	time_between = rng.randi_range(4000, 15000)

func _physics_process(delta: float) -> void:
	if !animated_sprite_2d.is_playing():
		if last_animation + time_between < Time.get_ticks_msec():
			last_animation = Time.get_ticks_msec()
			rng.randomize()
			time_between = rng.randi_range(7000, 20000)
			animated_sprite_2d.play()
