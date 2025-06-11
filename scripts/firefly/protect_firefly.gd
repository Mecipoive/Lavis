extends action_firefly
class_name protect_firefly

func init(firefly : Node2D, pStat : stat_firefly) -> void:
	super(firefly, pStat)
	pass

func effect_on_enter(firefly : Node2D, body : Node2D) -> void:
	super(firefly, body)
	if body.is_in_group("Ennemy"):
		body.list_action.append(self)
	pass

func effect_on_exit(firefly : Node2D, body : Node2D) -> void:
	super(firefly, body)
	if body.is_in_group("Ennemy"):
		body.list_action.erase(self)
		clean(body)
	pass

func physics_process(firefly : Node2D, delta : float) -> void:
	super(firefly, delta)
	pass

func process(firefly : Node2D, delta : float) -> void:
	pass
	
func process_for_player(player : CollisionObject2D):
	player.set_collision_layer_value(4, false)
	player.set_collision_mask_value(4, false)
	player.visible = false

func clean(player : CollisionObject2D):
	player.set_collision_layer_value(4, true)
	player.set_collision_mask_value(4, true)
	player.visible = true
