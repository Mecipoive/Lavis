extends Node2D

@onready var big: TextureRect = $big
@onready var small: TextureRect = $small
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var collision_shape_2d: Area2D = $Collision
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@export var action : action_firefly
@export var stat : stat_firefly

var noise : Noise = FastNoiseLite.new()
var speed_noise : float = 3.0

# light
var pos : float = 0.0
var scale_origin_big : Vector2
var scale_origin_light : Vector2

func _ready():
	### shader
	sprite_2d.material.set_shader_parameter("color_flame", stat.color)
	var texture_big : GradientTexture2D = big.texture
	#### color change
	var actual_color_big_0 = texture_big.gradient.get_color(0)
	var back_color_big_0 : Color = Color(stat.color.r, stat.color.g, stat.color.b, actual_color_big_0.a)
	texture_big.gradient.set_color(0, back_color_big_0)
	###
	var actual_color_big_1 = texture_big.gradient.get_color(1)
	var back_color_big_1 : Color = Color(stat.color.r, stat.color.g, stat.color.b, actual_color_big_1.a)
	texture_big.gradient.set_color(1, back_color_big_1)
	###
	var actual_color_big_2 = texture_big.gradient.get_color(2)
	var back_color_big_2 : Color = Color(stat.color.r, stat.color.g, stat.color.b, actual_color_big_2.a)
	texture_big.gradient.set_color(2, back_color_big_2)
	####
	big.size = stat.radius * Vector2.ONE
	big.position = sprite_2d.position - Vector2.ONE * big.size /2 
	big.position.y -= sprite_2d.sprite_frames.get_frame_texture("default", 0).get_size().y/2
	big.pivot_offset = -big.position
	
	var texture_small : GradientTexture2D = small.texture
	var actual_color_small_0 = texture_small.gradient.get_color(0)
	var back_color_small_0 : Color = Color(stat.color.r, stat.color.g, stat.color.b, actual_color_small_0.a)
	texture_small.gradient.set_color(0, back_color_small_0)
	var actual_color_small_1 = texture_small.gradient.get_color(1)
	var back_color_small_1 : Color = Color(stat.color.r, stat.color.g, stat.color.b, actual_color_small_1.a)
	texture_small.gradient.set_color(1, back_color_small_1)
	small.size = stat.radius * Vector2.ONE / 4
	small.position = sprite_2d.position - Vector2.ONE * small.size /2
	small.position.y -= sprite_2d.sprite_frames.get_frame_texture("default", 0).get_size().y/2
	small.pivot_offset = -small.position
	
	pos = randf_range(0, 1000)
	scale_origin_big = big.scale
	
	collision_shape_2d.scale = big.size * 0.031
	collision_shape_2d.position.y -= sprite_2d.sprite_frames.get_frame_texture("default", 0).get_size().y/2
	
	point_light_2d.scale = big.size * 0.0017
	point_light_2d.position.y -= sprite_2d.sprite_frames.get_frame_texture("default", 0).get_size().y/2
	
	scale_origin_light = point_light_2d.scale
	
	cpu_particles_2d.color = stat.color
	
	action.init(self, stat)

func _physics_process(delta : float):
	# cirle light change size 
	big.scale = scale_origin_big * (1 + noise.get_noise_1d(pos + Time.get_ticks_msec() * delta) * 0.05)
	small.scale = big.scale
	
	point_light_2d.scale = scale_origin_light * (1 + noise.get_noise_1d(pos + Time.get_ticks_msec() * delta) * 0.05)
	
	action.physics_process(self, delta)
	
func _on_body_exited(body: Node2D) -> void:
	action.effect_on_exit(self, body)

func _on_body_entered(body: Node2D) -> void:
	action.effect_on_enter(self, body)
