extends Spatial

func _process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()
	else:
		if $AnimationPlayer.current_animation_position < 0.06 :
			$AnimationPlayer.stop()



func shoot():
	play_animation()

func play_animation():
	$AnimationPlayer.play("Cube002Action")
