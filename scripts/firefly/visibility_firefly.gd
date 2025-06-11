extends action_firefly
class_name visiblity_firefly

func init(firefly : Node2D, pStat : stat_firefly) -> void:
	super(firefly, pStat)
	firefly.point_light_2d.range_item_cull_mask = 0b11
	pass

func effect_on_enter(firefly : Node2D, body : Node2D) -> void:
	super(firefly, body)
	if body.is_in_group("Player"):
		body.list_action.append(self)
	pass

func effect_on_exit(firefly : Node2D, body : Node2D) -> void:
	super(firefly, body)
	if body.is_in_group("Player"):
		body.list_action.erase(self)
		clean(body)
	pass

func physics_process(firefly : Node2D, delta : float) -> void:
	super(firefly, delta)
	pass

func process(firefly : Node2D, delta : float) -> void:
	pass
	
func process_for_player(player : CollisionObject2D):
	player.set_collision_mask_value(2, true)

func clean(player : CollisionObject2D):
	player.set_collision_mask_value(2, false)
	pass
