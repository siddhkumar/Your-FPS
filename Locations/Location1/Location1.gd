extends Spatial


func _ready():
	for i in get_node("BuildingBlocks").get_children():
		i.create_trimesh_collision ( )
