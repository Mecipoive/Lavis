extends Node

@onready var all: AudioStreamPlayer = $All

@onready var actual_music : AudioStreamPlayer = all
@onready var indexToPlay : int = 1

var min_sound := -10.0

var b_reduce_sound = false
var speed_change_sound = 10

func stop():
	actual_music.stop()

func play():
	if !actual_music.playing:
		actual_music.play()


func _process(delta: float) -> void:
	if b_reduce_sound:
		actual_music.volume_db = clamp(actual_music.volume_db - speed_change_sound * delta, min_sound, 0.0)
	else:
		actual_music.volume_db = clamp(actual_music.volume_db + speed_change_sound * delta, min_sound, 0.0)
func reduce_sound(b : bool):
	b_reduce_sound = b


func change_music_by_level_index(index: int) -> bool:
	if indexToPlay == index:
		return false
	if(index <= 4):
		if index == 2:
			actual_music["parameters/switch_to_clip"] = "Help Him Part 1"
		elif index == 4 :
			actual_music["parameters/switch_to_clip"] = "Help Him Part 2"
	elif(index < 8):
		
		if index == 5:
			actual_music["parameters/switch_to_clip"] = "Blue Part 1"
		elif index == 6 :
			actual_music["parameters/switch_to_clip"] = "Blue Part 2"
		elif index == 7 :
			actual_music["parameters/switch_to_clip"] = "Blue Part 3"
				
	elif(index < 12):
		
		if index == 8:
			actual_music["parameters/switch_to_clip"] = "Need To Think Start"
		elif index == 9:
			actual_music["parameters/switch_to_clip"] = "Need To Think Mid"
		elif index == 10:
			actual_music["parameters/switch_to_clip"] = "Need To Think End"
		
	else:
		if index == 12:
			actual_music["parameters/switch_to_clip"] = "Finale Red Part 1"
		elif index == 13:
			actual_music["parameters/switch_to_clip"] = "Finale Red Part 2"
		elif index == 14:
			actual_music["parameters/switch_to_clip"] = "Finale Red Part 3"
		elif index == 15:
			actual_music["parameters/switch_to_clip"] = "Finale Red Part 4"
		elif index == 16:
			actual_music["parameters/switch_to_clip"] = "Finale Red Part 5"
	
	
	if index == 20:
		actual_music["parameters/switch_to_clip"] = "LSD"

	if !actual_music.playing:
		play()
	indexToPlay = index
	return true
