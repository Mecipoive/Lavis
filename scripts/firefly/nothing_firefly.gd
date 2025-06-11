extends action_firefly
class_name nothing_firefly

func effect_on_enter(firefly : Node2D, body : Node2D) -> void:
	super(firefly, body)
	pass
func effect_on_exit(firefly : Node2D, body : Node2D) -> void:
	super(firefly, body)
	pass

func init(firefly : Node2D, p_stat : stat_firefly) -> void:
	super(firefly, p_stat)
	pass

func process(firefly : Node2D, delta : float) -> void:
	pass

func physics_process(firefly : Node2D, delta : float) -> void:
	super(firefly, delta)
	pass

func process_for_player(player : CollisionObject2D):
	pass

func clean(player : CollisionObject2D):
	pass
