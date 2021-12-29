extends Spatial

onready var audio_player = $AudioStreamPlayer

var counting_to_stop = false
var counting_to_start = true
var count_stop = 0
var count_start = 0
var stopped_at = 0

const time_to_stop_audio = 0.25
const time_to_start_audio = 0.25

func play():
	counting_to_stop = false
	audio_player.volume_db = 0
	counting_to_start = true
	stopped_at = 0
	pass

func is_playing():
	return audio_player.playing
	pass

func stop():
	counting_to_start = false
	counting_to_stop = true
	pass

func _physics_process(delta):
	print(audio_player.volume_db)
	if counting_to_start:
		audio_player.play(stopped_at)
		count_start += delta
		audio_player.volume_db += 0.0333
	
	if count_start > time_to_start_audio:
		counting_to_start = false
		count_start = 0
	
	
	
	if counting_to_stop:
		count_stop += delta 
		audio_player.volume_db -= 0.0333
	
	if count_stop > time_to_stop_audio:
		stopped_at = audio_player.get_playback_position()
		audio_player.volume_db = 0
		count_stop = 0
		counting_to_stop = false 
		audio_player.stop()
