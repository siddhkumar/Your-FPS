extends Spatial

var time = 0
var time_between_bullets = 0.2

func _process(delta):
	time += delta
	if Input.is_action_pressed("shoot") and time > time_between_bullets:
		shoot()
		time = 0
	
	if !Input.is_action_pressed("shoot"):
		if $AnimationPlayer.current_animation_position < 0.06 :
			$AnimationPlayer.stop()



func shoot():
	play_animation()
	muzzle_flash()

func play_animation():
	$AnimationPlayer.play("Cube002Action")

func muzzle_flash():
	$Cube002/MuzzleFlash.emitting = true
