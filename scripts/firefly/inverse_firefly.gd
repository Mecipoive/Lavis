extends action_firefly
class_name inverse_firefly

func effect_on_enter(_firefly : Node2D, body : Node2D) -> void:
	super(_firefly, body)
	if body.is_in_group("Player"):
		body.list_action.append(self)
	pass

func effect_on_exit(_firefly : Node2D, body : Node2D) -> void:
	super(_firefly, body)
	if body.is_in_group("Player"):
		body.list_action.erase(self)
		clean(body)
	pass

func init(_firefly : Node2D, p_stat : stat_firefly) -> void:
	super(_firefly, p_stat)
	pass

func process(firefly : Node2D, delta : float) -> void:
	super(firefly, delta)
	pass

func physics_process(_firefly : Node2D, _delta : float) -> void:
	super(_firefly, _delta)
	pass

func process_for_player(player : CollisionObject2D):
	player.animated_sprite.flip_v = true
	player.animated_sprite_invert.flip_v = true
	
	if player.GRAVITY > 0:
		player.GRAVITY *= -1
		player.FALL_GRAVITY *= -1
		player.FAST_FALL_GRAVITY *= -1
		player.JUMP_VELOCITY *= -1

func clean(player: CollisionObject2D):
	if player.GRAVITY < 0:
		player.animated_sprite.flip_v = false
		player.animated_sprite_invert.flip_v = false
		
		player.GRAVITY *= -1
		player.FALL_GRAVITY *= -1
		player.FAST_FALL_GRAVITY *= -1
		player.JUMP_VELOCITY *= -1
