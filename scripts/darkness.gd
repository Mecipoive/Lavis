extends Node2D

@export var lvl : Node2D

@onready var pivot_left: Node2D = $Pivot_left
@onready var pivot_right: Node2D = $pivot_right

@onready var right_child = pivot_right.get_children()[0]
@onready var left_child =  pivot_left.get_children()[0]

@onready var shadow: Player 

var default_position = Vector2(0,0)
var max_dist = 5
var right_dir
var left_dir
var dist

var playmode

var is_pressed = false

func _ready() -> void:
	shadow = get_tree().get_first_node_in_group("Player")
	_on_level_1_mode_changed(false)
	lvl.mode_changed.connect(_on_level_1_mode_changed)


func _physics_process(delta: float) -> void:
	
	var pos_to_follow = Vector2.ZERO
	if playmode:
		if shadow == null:
			shadow = get_tree().get_first_node_in_group("Player")
		pos_to_follow = shadow.global_position
	else:
		pos_to_follow = get_global_mouse_position()

	right_dir = right_child.global_position.direction_to(pos_to_follow)
	left_dir = left_child.global_position.direction_to(pos_to_follow)
	dist = pos_to_follow.length()
	right_child.position = right_dir * min(dist, max_dist)
	left_child.position = left_dir * min(dist, max_dist)
	
		


func _unhandled_input(event: InputEvent) -> void:
	if !playmode and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		if event.pressed:
			set_physics_process(true)
		else:
			set_physics_process(false)
			right_child.position = default_position
			left_child.position = default_position
		
		

func _on_level_1_mode_changed(is_playmode: Variant) -> void:
	playmode = is_playmode
	if !playmode:
		set_physics_process(false)
		right_child.position = default_position
		left_child.position = default_position
	else:
		set_physics_process(true)
