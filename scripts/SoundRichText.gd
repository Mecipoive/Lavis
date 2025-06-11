extends RichTextLabel

@onready var audio_stream_player: AudioStreamPlayer
var elipse_between_sound := 300

var epsilon = 0.01

var last_time := Time.get_ticks_msec()
var last_visible_ratio := 0.0

var pitch_scale_adjust := -0.1
func _init():
	audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.autoplay = true
	audio_stream_player.stream = preload("res://assets/sfx/daddy_reverb.wav")

func _physics_process(delta: float) -> void:
	if (
		abs(last_visible_ratio - visible_ratio) > epsilon and
		visible_ratio > 0.0 and visible_ratio < 1.0 and
		last_time + elipse_between_sound < Time.get_ticks_msec()
	):
		last_time = Time.get_ticks_msec()
		last_visible_ratio = visible_ratio
		var new_audio_player : AudioStreamPlayer = audio_stream_player.duplicate()
		new_audio_player.volume_db += 5
		new_audio_player.pitch_scale += randf_range(-0.1 + pitch_scale_adjust, 0.1 + pitch_scale_adjust)
		if text[-1] in ["a", "e", "i", "o", "u", "y"]:
			new_audio_player.pitch_scale += 0.2
		elif text[-1] in [",", ";", "?", "!", "."]:
			new_audio_player.pitch_scale -= 0.2
		get_tree().root.add_child(new_audio_player)
		await new_audio_player.finished
		new_audio_player.queue_free()
	
	if visible_ratio == 1.0 and last_visible_ratio != 1.0:
		last_visible_ratio = visible_ratio
		var new_audio_player : AudioStreamPlayer = audio_stream_player.duplicate()
		new_audio_player.volume_db += 5
		new_audio_player.pitch_scale += randf_range(-0.1 + pitch_scale_adjust, 0.1 + pitch_scale_adjust)
		new_audio_player.pitch_scale -= 0.1
		get_tree().root.add_child(new_audio_player)
		await new_audio_player.finished
		new_audio_player.queue_free()
