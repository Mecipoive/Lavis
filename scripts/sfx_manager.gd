extends Node2D

var sound_effect_dict = {}

@export var sound_effects_settings : Array[SoundEffectSettings]


func _ready() -> void:
	for sound_effects_setting : SoundEffectSettings in sound_effects_settings:
		sound_effect_dict[sound_effects_setting.type] = sound_effects_setting
		
func create_audio(type: SoundEffectSettings.SOUND_EFFECT_TYPE):
	if sound_effect_dict.has(type):
		var sound_effect_setting : SoundEffectSettings = sound_effect_dict[type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var new_audio = AudioStreamPlayer.new()
			add_child(new_audio)
			new_audio.stream = sound_effect_setting.sound_effect
			new_audio.volume_db = sound_effect_setting.volume
			new_audio.pitch_scale = sound_effect_setting.pitch_scale
			new_audio.finished.connect(sound_effect_setting.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
