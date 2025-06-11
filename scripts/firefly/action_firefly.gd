extends Resource
class_name action_firefly

var stat : stat_firefly

func effect_on_enter(_firefly : Node2D, _body : Node2D) -> void:
	pass

func effect_on_exit(_firefly : Node2D, _body : Node2D) -> void:
	pass

func init(_firefly : Node2D, p_stat : stat_firefly) -> void:
	stat = p_stat
	pass

func process(firefly : Node2D, delta : float) -> void:
	pass

func physics_process(_firefly : Node2D, _delta : float) -> void:
	pass

func process_for_player(player : CollisionObject2D):
	pass

func clean(player : CollisionObject2D):
	pass
