extends KinematicBody

var speed
var default_move_speed = 7
var crouch_move_speed = 3
var sprint_move_speed = 10
var crouch_speed = 20
var acceleration = 20
var gravity = 28
var jump = 10

var jump_num = 0

var default_height = 1.5
var crouch_height = 0.5

var mouse_sensitivity = 0.05

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head
onready var pcap = $CollisionShape
onready var bonker = $Headbonker
onready var anim_play = $Head/Camera/AnimationPlayer
onready var gun = $Head/Camera/gun1
onready var footstep_audio_player = $FootstepAudioPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func maintain_camera():
	#if get_parent().get_name() == "Location1":
	if is_network_master():
		$Head/Camera/gun1.enabled = true
		$Head/Camera.current = true

func _input(event):
		if event is InputEventMouseMotion and is_network_master():
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	maintain_camera()
	
	if is_network_master():
		basic_controls(delta)
		footstep_audio()
	rpc("rem" , transform)
	


#If is network master
func basic_controls(delta):
	var head_bonked = false
	
	speed = default_move_speed
	
	direction = Vector3()
	
	if bonker.is_colliding():
		head_bonked = true
	
	if is_on_floor() and !Input.is_action_just_pressed("jump") and !Input.is_action_pressed("move_forward") and !Input.is_action_pressed("move_backward") and !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		fall = Vector3(0,0,0)
	if is_on_floor():
		jump_num = 0

	if not is_on_floor():
		fall.y -= gravity * delta
	
	
	if Input.is_action_just_pressed("jump")and is_on_floor():
		if jump_num == 0:
			fall.y = jump
			jump_num = 1
			
	if head_bonked:
		fall.y = -2
			
	if Input.is_action_just_pressed("jump")and not is_on_floor():
		if jump_num == 1:
			fall.y = jump
			jump_num = 2
	
	if Input. is_action_pressed("crouch"):
		pcap.shape.height -= crouch_speed * delta
		speed = crouch_move_speed
	elif not head_bonked:
		pcap.shape.height += crouch_speed * delta
		
	if Input. is_action_pressed("sprint"):
			speed = sprint_move_speed
		
	pcap.shape.height = clamp(pcap.shape.height, crouch_height, default_height)
	
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
		
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	
	
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	move_and_slide(fall, Vector3.UP)
	
	if direction != Vector3():
		anim_play.play("Head Bob")

func footstep_audio():
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if !footstep_audio_player.is_playing():
			footstep_audio_player.play()
	
	if !Input.is_action_pressed("move_forward") and !Input.is_action_pressed("move_backward") and !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		if footstep_audio_player.is_playing():
			footstep_audio_player.stop()

#Called remotely

remote func rem(og):
	if not is_network_master():
		transform = og



