extends Spatial

onready var audio_player = $AudioStreamPlayer

var counting = false
var count = 0
var stopped_at = 0

const time_to_stop_audio = 0.3

func play():
	audio_player.play(stopped_at)
	stopped_at = 0
	pass

func is_playing():
	return audio_player.playing
	pass

func stop():
	counting = true
	pass

func _process(delta):
	if counting:
		count += delta 
		audio_player.volume_db -= 0.5
	
	if count > time_to_stop_audio:
		stopped_at = audio_player.get_playback_position()
		audio_player.volume_db = 0
		count = 0
		counting = false 
		audio_player.stop()
