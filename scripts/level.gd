extends Node2D


signal level_changed(level_number)
signal mode_changed(is_playmode)

@export var level_number: int = 1
@export var cam_max_zoom: Vector2

@onready var shadow: Player = $PlayModeObject/Shadow
@onready var shadow_position: Vector2 
@onready var animation_player: AnimationPlayer = $PlayModeObject/AnimationPlayer
@onready var camera_2d: Camera2D = $PlayModeObject/Camera2D
@onready var inventory: Area2D = $EditModeObject/Inventory
@onready var play_mode_object: Node = $PlayModeObject
@onready var edit_mode_object: Node = $EditModeObject
@onready var darkness_bottom: Node = $EditModeObject/Decor_bottom
@onready var darkness_top: Node = $EditModeObject/Decor_top

var speed_cam := 600
var isPlayMode := false
var can_change_mode := true

var hidden_pickables : Array[Node2D]



func _ready() -> void:
	
	shadow.set_physics_process(false)
	shadow_position = shadow.position
	inventory.body_entered.connect(_on_inventory_body_entered)
	inventory.body_exited.connect(_on_inventory_body_exited)

func is_is_visible(b : bool):
	for i in play_mode_object.get_children():
		if "visible" in i:
			i.visible = b
	for i in edit_mode_object.get_children():
		if "visible" in i:
			i.visible = b
	if b:
		for pickable in get_tree().get_nodes_in_group("Pickable"):
			if pickable.has_method("in_scene_play"):
				pickable.in_scene_edit()
func clean():
	for pick in hidden_pickables:
		pick.enter_inventory()
	hidden_pickables.clear()

func stop():
	inventory.body_entered.disconnect(_on_inventory_body_entered)
	inventory.body_exited.disconnect(_on_inventory_body_exited)
func initialize_level():
	inventory.position.x += 500
	for instance in get_tree().get_nodes_in_group("Ennemy"):
		if instance.has_signal("body_entered"):
			instance.body_entered.connect(_on_death_zone_body_entered)
	for instance in get_tree().get_nodes_in_group("Light_only"):
		if instance is CanvasItem:
			var mat: CanvasItemMaterial = CanvasItemMaterial.new()
			mat.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
			instance.material = mat
	inventory.position.x -= 500
func change_mode():
	isPlayMode = !isPlayMode
	if isPlayMode: # play mode
		shadow.set_physics_process(true)
		for pickable in get_tree().get_nodes_in_group("Pickable"):
			if pickable.has_method("in_scene_play"):
				var b : bool = !hidden_pickables.has(pickable)
				pickable.in_scene_play(b)
		for instance in get_tree().get_nodes_in_group("Light_only"):
			if instance is CanvasItem:
				instance.material.light_mode = CanvasItemMaterial.LIGHT_MODE_LIGHT_ONLY
		for instance in darkness_bottom.get_children():
			instance.visible = false
		for instance in darkness_top.get_children():
			instance.visible = false
		MusicManager.reduce_sound(false)
	else: # edit mode
		reset_level()
		shadow.can_dash = true
		shadow.set_physics_process(false)
		for pickable in get_tree().get_nodes_in_group("Pickable"):
			if pickable.has_method("in_scene_edit"):
				pickable.in_scene_edit()
		for instance in get_tree().get_nodes_in_group("Light_only"):
			if instance is CanvasItem:
				instance.material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
		for instance in darkness_bottom.get_children():
			instance.visible = true
		for instance in darkness_top.get_children():
			instance.visible = true
		MusicManager.reduce_sound(true)
	mode_changed.emit(isPlayMode)

func reset_level():
	SfxManager.create_audio(SoundEffectSettings.SOUND_EFFECT_TYPE.DEATH)
	shadow.position = shadow_position
	shadow.velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if isPlayMode:
		camera_2d.zoom = clamp(camera_2d.zoom + Vector2.ONE * speed_cam * delta * 0.001, 0.8 * cam_max_zoom * Vector2.ONE, cam_max_zoom)
	else:
		camera_2d.zoom = clamp(camera_2d.zoom - Vector2.ONE * speed_cam * delta * 0.001, 0.8 * cam_max_zoom * Vector2.ONE, cam_max_zoom)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("change_mode") and can_change_mode:
		change_mode()

func _on_next_level_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_physics_process(false)
		### add score
		var a : Array[stat_icon] = []
		for pickable in get_tree().get_nodes_in_group("Pickable"):
			if !hidden_pickables.has(pickable):
				a.append(pickable.icon)
		ScoreManager.add_icon(a)
		###
		emit_signal("level_changed", level_number)

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		shadow.set_physics_process(false)
		animation_player.play("Death_animation_in")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Death_animation_in":
			reset_level()
			animation_player.play("Death_animation_out")
			if isPlayMode:
				shadow.set_physics_process(true)

func clean_queue_free():
	queue_free()

func _on_inventory_body_entered(body: Node2D) -> void:
	if body.is_in_group("Pickable"):
		hidden_pickables.append(body)
		body.enter_inventory()

func _on_inventory_body_exited(body: Node2D) -> void:
	if body.is_in_group("Pickable"):
		hidden_pickables.erase(body)
		body.exit_inventory()
