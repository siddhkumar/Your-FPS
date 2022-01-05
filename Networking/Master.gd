extends Spatial

var peer
const DEFAULT_PORT = 3957
const MAX_PEERS = 4

func _process(delta):
	#used to rotate camera
	$Camera.rotate_y(0.001)

func _on_Host_Button_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(peer)
	get_tree().connect("network_peer_connected" , self , "_peer_connected")
	GlobalProperties.self_ip = get_self_ip()[0]
	setup_location_server()

func get_self_ip():
	var matched_ips = []
	for address in IP.get_local_addresses():
		if (address.split('.').size() == 4) and address != "127.0.0.1":
			matched_ips.append(address)
	return matched_ips

func _peer_connected(id):
	GlobalProperties.peer_list.append(id)
	add_latest_player()

func add_latest_player():
	if GlobalProperties.peer_list.size() != 0:
		add_player(GlobalProperties.peer_list.back() , true)


func setup_location_server():
	$CanvasLayer.queue_free()
	$Camera.queue_free()
	set_process(false)
	var world = preload("res://Locations/Location1/Location1.tscn").instance()
	add_child(world)
	add_player(get_tree().get_network_unique_id() , false)


func setup_location_client():
	$CanvasLayer.queue_free()
	$Camera.queue_free()
	set_process(false)
	var world = preload("res://Locations/Location1/Location1.tscn").instance()
	add_child(world)
	add_player(get_tree().get_network_unique_id() , false)
	add_player(1 , true)

func _on_Join_Button_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.create_client($CanvasLayer/IPEntry.text, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	get_tree().connect("connected_to_server" , self , "_connected_to_server")


func _connected_to_server():
	get_tree().connect("network_peer_connected" , self , "_peer_connected")
	setup_location_client()

func add_player(id , col_dis):
	var new_player = preload("res://Player/Player.tscn").instance()
	new_player.set_network_master(id)
	new_player.set_name(str(id))
	new_player.transform.origin.y = 3
	#new_player.transform.origin.x = rand_range(1.0 , 3.0)
	new_player.get_node("CollisionShape").disabled = col_dis
	add_child(new_player)
