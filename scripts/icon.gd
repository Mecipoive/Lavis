extends CharacterBody2D

@export var attach_object : Node2D
@export var icon : stat_icon

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var circle: TextureRect = $Circle

signal clicked
var held := false

func _ready():
	attach_object.visible = false
	sprite_2d.texture = icon.sprite
	collision_shape_2d.position = sprite_2d.position
	collision_shape_2d.shape.size = sprite_2d.texture.get_size()
	
	var texture := circle.texture
	var stat = attach_object.stat
	####
	var actual_color = texture.gradient.get_color(1)
	var back_color : Color = Color(stat.color.r, stat.color.g, stat.color.b, actual_color.a)
	print(self, " - ", stat.color)
	print(self, " - ", back_color)
	texture.gradient.set_color(1, back_color)
	####
	circle.size = attach_object.big.size
	circle.scale = attach_object.big.scale
	circle.global_position -= Vector2(circle.size.x/2, circle.size.y/2)

func in_scene_play(can_see_object : bool = true):
	attach_object.global_transform.origin = global_transform.origin
	attach_object.visible = can_see_object
	attach_object.collision_shape_2d.disabled = !can_see_object
	visible = false

func in_scene_edit():
	attach_object.visible = false
	attach_object.global_position = Vector2(-630, -460)
	visible = true

func _physics_process(delta: float) -> void:
	if held:
		global_transform.origin = get_global_mouse_position()

func pickup():
	if held:
		return
	held = true

func enter_inventory() -> void:
	circle.visible = false
	
func exit_inventory() -> void:
	circle.visible = true

func drop():
	if held:
		held = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)
