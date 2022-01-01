extends Spatial

var count = 0
var limit = 0.0
var limit_lighting = 0.2

func _ready():
	limit = rand_range(3.0 , 20.0)

func _process(delta):
	count += delta
	if count > limit:
		count = 0
		limit = rand_range(20.0 , 60.0)
		$ThunderSound.play()
		$Lightning.visible = true
	
	if count > limit_lighting:
		$Lightning.visible = false

