extends Node

var peers: PackedInt32Array
var id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var pos: Marker2D
	pos = $Marker2D
	
	if multiplayer.is_server(): id = 1
	else: id = multiplayer.get_unique_id()
	
	multiplayer.peer_connected.connect(_connected_peer)
	multiplayer.peer_disconnected.connect(_disconnected_peer)
	multiplayer.server_disconnected.connect(_server_disconnected)
	
	peers = PackedInt32Array([id]) + multiplayer.get_peers()
	print(peers)
	for peer in peers:
		var player = preload("res://pre_game_start/play_1.tscn").instantiate()
		player.name = str(peer)
		player.set_multiplayer_authority(peer)
		player.global_transform = pos.global_transform
		add_child(player)
	
func _connected_peer(id: int) -> void:
	peers.append(id)
	var pos: Marker2D
	pos = $Marker2D
	print(peers)
	var player = preload("res://pre_game_start/play_1.tscn").instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)
	player.global_transform = pos.global_transform
	add_child(player)
	
func _disconnected_peer(id: int) -> void:
	for node in get_children():
		if node.name == str(id):
			node.queue_free()

func _server_disconnected() -> void:
	print("Сервер отключился!")
	AutoloadNet.main_menu.show()
	queue_free()
