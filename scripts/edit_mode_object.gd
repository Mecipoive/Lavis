extends Node

var held_object : CharacterBody2D = null

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("Pickable"):
		node.clicked.connect(_on_pickable_object)

func _on_pickable_object(object : CharacterBody2D):
	if !held_object:
		object.pickup()
		held_object = object

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop()
			held_object = null
