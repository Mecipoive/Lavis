extends Node2D

var icons_used : Array[stat_icon]

var start : float = 0.0
var time_result : float

func _ready() -> void:
	begin_game()

func begin_game() -> void:
	icons_used.clear()
	time_result = 0.0
	start = Time.get_ticks_msec()

func add_icon(icons : Array[stat_icon]):
	icons_used.append_array(icons)

func end_game() -> void:
	time_result = Time.get_ticks_msec() - start

func get_time_score() -> Array[int]:
	if time_result == 0.0:
		return Array()
	var second : int = time_result/1000
	var minute : int = second/60
	second %= 60
	var a : Array[int] = [minute, second]
	return a

func get_dictionnary_icons() -> Array[stat_icon]:
	return icons_used
