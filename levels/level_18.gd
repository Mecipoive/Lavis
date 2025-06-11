extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var thank_you: Label = $"Thank you"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.stop()
	ScoreManager.end_game()
	var Chrono = ScoreManager.get_time_score()
	var number_of_flies = ScoreManager.icons_used.size()
	thank_you.text = "Thank you for playing our game ! \n You've beaten the game in " + str(Chrono[0]) + " minutes and " + str(Chrono[1])+ " seconds\n and " + str(number_of_flies) + " fire flies helped you guiding the way !"
	
	
	animation_player.play("Ending")


func play_song():
	MusicManager.change_music_by_level_index(20)
	MusicManager.reduce_sound(false)
