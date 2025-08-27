extends Node2D

var ip: String
var port: int
var host_port: int
var user_name: String
var user_name_set: Button
var slots: int

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	ip = (get_node("join_container/IP_ui_box/ip")as LineEdit).text
	port = (get_node("join_container/port_ui_box/port") as SpinBox).get_line_edit().text.to_int()
	host_port = (get_node("host_container/host_port_ui_box/host_port") as SpinBox).get_line_edit().text.to_int()
	slots = (get_node("host_container/host_clients_ui_box/slots") as SpinBox).get_line_edit().text.to_int()
	user_name = (get_node("profile_container/name_box/user_name") as LineEdit).text
	user_name_set = (get_node("profile_container/save_button") as Button)
	user_name_set.button_down.connect(_on_button_user_data_update_pressed)
	
	
	
func _on_button_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	var erc = peer.create_server(host_port, slots)
	if erc != 0:
		print("Запуск неудаолся!")
		return
	print("Запуск сервера...")
	multiplayer.multiplayer_peer = peer
	_change_scene()

func _on_button_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	print("Запуск клиента...")
	multiplayer.multiplayer_peer = peer


# Срабатывает только у сервера, когда подключается клиент
func _on_peer_connected(id: int) -> void:
	print("Клиент подключился:", id)
	
	AutoloadNet.server_peers = multiplayer.get_peers()
	print(AutoloadNet.server_peers) 

# Срабатывает у клиента, когда он подключился к серверу
func _on_connected_to_server() -> void:
	print("Клиент: подключение к серверу успешно")
	await get_tree().process_frame
	
	var uuid = multiplayer.get_unique_id()
	print(uuid)
	AutoloadNet.user_id = uuid
	_change_scene()

# Если не удалось подключиться
func _on_connection_failed() -> void:
	print("Ошибка: не удалось подключиться к серверу")

# Если сервер закрыл соединение
func _on_server_disconnected() -> void:
	print("Отключено от сервера")

func _change_scene() -> void:
	AutoloadNet.main_menu = self
	var game = preload("res://pre_game_start/game_stert_menu.tscn").instantiate()
	get_tree().get_root().add_child(game)
	hide()

##################
# настройка себя #
##################

func _on_button_user_data_update_pressed() -> void:
	AutoloadNet.user_name = user_name
