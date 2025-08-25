extends Node

var pos1
var pos2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	
	pos1 = $Marker2D
	pos2 = $Marker2D2
	print(AutoloadNet.server_peers[0],AutoloadNet.server_peers[1])

	var player2 = preload("res://pre game start/play_1.tscn").instantiate()
	player2.name = str(AutoloadNet.server_peers[0])
	player2.set_multiplayer_authority(AutoloadNet.server_peers[0])
	player2.global_transform = pos2.global_transform
	add_child(player2)
	
	if not multiplayer.is_server():
		return
		
	var player1 = preload("res://pre game start/play_1.tscn").instantiate()
	player1.name = str(1)
	player1.set_multiplayer_authority(1)
	player1.global_transform = pos1.global_transform
	add_child(player1)
