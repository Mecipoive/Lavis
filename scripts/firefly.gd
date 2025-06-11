extends StaticBody2D
class_name fireflyScene

var noise : Noise = FastNoiseLite.new()
var speed_noise : float = 3.0
@export var stat : animated_stat_firefly
@export var action : action_firefly
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var big : TextureRect = $big
@onready var small : TextureRect = $small
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var point_light_2d: PointLight2D = $PointLight2D


var pos : float = 0.0
var scale_origin_big : Vector2
var scale_origin_light : Vector2

func _ready():
	action = action.duplicate()
	stat = stat.duplicate()

	sprite_2d.sprite_frames = stat.spriteframes
	sprite_2d.play()
	
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
	small.pivot_offset = -small.position
	
	pos = randf_range(0, 1000)
	scale_origin_big = big.scale
	
	collision_shape_2d.scale = big.size * 0.033
	point_light_2d.scale = big.size * 0.0017
	scale_origin_light = point_light_2d.scale
	
	action.init(self, stat)
	
func _physics_process(delta : float):
	# cirle light change size 
	big.scale = scale_origin_big * (1 + noise.get_noise_1d(pos + Time.get_ticks_msec() * delta) * 0.05)
	small.scale = big.scale
	
	point_light_2d.scale = scale_origin_light * (1 + noise.get_noise_1d(pos + Time.get_ticks_msec() * delta) * 0.05)
	
	action.physics_process(self, delta)
	


func set_transparence(b : bool) -> void:
	big.visible = !b
	small.visible = !b
	sprite_2d.material.set_shader_parameter("is_transparent", b)

func _process(delta: float) -> void:
	action.process(self, delta)

func _on_body_exited(body: Node2D) -> void:
	action.effect_on_exit(self, body)


func _on_body_entered(body: Node2D) -> void:
	action.effect_on_enter(self, body)


func _on_area_2d_area_entered(area: Area2D) -> void:
	action.effect_on_enter(self, area)


func _on_area_2d_area_exited(area: Area2D) -> void:
	action.effect_on_exit(self, area)
