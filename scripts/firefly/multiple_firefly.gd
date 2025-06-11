extends action_firefly
class_name multiple_firefly

@export var list_action : Array[action_firefly]

func effect_on_enter(_firefly : Node2D, body : Node2D) -> void:
	super(_firefly, body)
	for action in list_action:
		action.effect_on_enter(_firefly, body)

func effect_on_exit(_firefly : Node2D, body : Node2D) -> void:
	super(_firefly, body)
	for action in list_action:
		action.effect_on_exit(_firefly, body)

func init(firefly : Node2D, p_stat : stat_firefly) -> void:
	super(firefly, p_stat)
	for action in list_action:
		action.init(firefly, p_stat)

func process(firefly : Node2D, delta : float) -> void:
	super(firefly, delta)
	for action in list_action:
		action.process(firefly, delta)

func physics_process(firefly : Node2D, delta : float) -> void:
	super(firefly, delta)
	for action in list_action:
		action.physics_process(firefly, delta)

func process_for_player(player : CollisionObject2D):
	super(player)
	for action in list_action:
		action.process_for_player(player)

func clean(player: CollisionObject2D):
	super(player)
	for action in list_action:
		action.clean(player)
