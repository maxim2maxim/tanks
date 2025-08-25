extends Node2D

var ip_text_node
var port_text_node
var port_host_text_node
var user_name_node

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	ip_text_node = get_node("join_container/IP_ui_box/ip")
	port_text_node = get_node("join_container/port_ui_box/port")
	port_host_text_node = get_node("host_container/host_port_ui_box/host_port")
	user_name_node = get_node("profil_container/Button_user_data_update")
	
	
	
func _on_button_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(port_host_text_node.text), 2)
	multiplayer.multiplayer_peer = peer

func _on_button_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_text_node.text, int(port_text_node.text))
	multiplayer.multiplayer_peer = peer


# Срабатывает только у сервера, когда подключается клиент
func _on_peer_connected(id: int) -> void:
	print("Клиент подключился:", id)
	
	AutoloadNet.server_peers = multiplayer.get_peers()
	print(AutoloadNet.server_peers) 
	
	
	_change_scene()

# Срабатывает у клиента, когда он подключился к серверу
func _on_connected_to_server() -> void:
	print("Клиент: подключение к серверу успешно")
	await get_tree().process_frame
	
	print(multiplayer.get_unique_id())
	AutoloadNet.user_id = multiplayer.get_unique_id()
	_change_scene()

# Если не удалось подключиться
func _on_connection_failed() -> void:
	print("Ошибка: не удалось подключиться к серверу")

# Если сервер закрыл соединение
func _on_server_disconnected() -> void:
	print("Отключено от сервера")

func _change_scene() -> void:
	var game = preload("res://pre game start/game_stert_menu.tscn").instantiate()
	get_tree().get_root().add_child(game)
	hide()

##################
# настройка себя #
##################

func _on_button_user_data_update_pressed() -> void:
	AutoloadNet.user_name = user_name_node.text
