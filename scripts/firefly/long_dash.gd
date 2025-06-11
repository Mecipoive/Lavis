extends action_firefly
class_name long_dash_firefly

var last_touch : int = Time.get_ticks_msec()
var epsilon : int = 2e3
var hidden := false
var fly = null

var time_addition := 0.3


func effect_on_enter(firefly : Node2D, body : Node2D) -> void:
	super(firefly, body)
	if body.is_in_group("Player"):
		fly = firefly
		body.list_action.append(self)
	pass

func effect_on_exit(firefly : Node2D, body : Node2D) -> void:
	super(firefly, body)
	if body.is_in_group("Player"):
		body.list_action.erase(self)
		clean(body)
	pass

func init(firefly : Node2D, p_stat : stat_firefly) -> void:
	super(firefly, p_stat)
	pass

func process(firefly : Node2D, delta : float) -> void:
	super(firefly, delta)
	if hidden and last_touch + epsilon < Time.get_ticks_msec():
		#print(self, " Im visible")
		firefly.visible = true
		hidden = false

func physics_process(firefly : Node2D, delta : float) -> void:
	super(firefly, delta)
	pass

func process_for_player(player : CollisionObject2D):
	if player.is_in_group("Player") and !hidden and !player.can_dash and player.timer_dash != null:
		player.timer_dash.set_time_left(player.timer_dash.time_left + time_addition)
		player.velocity.y = -( abs(player.velocity.x) + abs(player.velocity.y))
		player.velocity.x = 0.0
		player.can_dash = true
		last_touch = Time.get_ticks_msec()
		fly.visible = false
		hidden = true

func clean(player : CollisionObject2D):
	fly = null
