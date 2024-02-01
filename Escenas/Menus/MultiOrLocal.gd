extends Control


func _on_btn_crear_server_pressed() -> void:
	Eventos.singleplayer = false
	Eventos.multiOnline = true
	MultiplayerControl.isHost = true
	Names.generar_nombres()
	MultiplayerControl.peer  = await GotmMultiplayer.create_server()
	MultiplayerControl.multiplayer.multiplayer_peer = MultiplayerControl.peer
	MultiplayerControl.multiplayer.peer_connected.connect(func(id): MultiplayerControl.clientId = id)
	# Players can join using this address.
	MultiplayerControl.address = await GotmMultiplayer.get_address()
	
	# Bobada de remplazar sstrings para que no parezca una IP
	var code = MultiplayerControl.address.replace(":","Z").to_upper().substr(2,-1)
	$LineAddressCopy.text = code
	loaded_peer.rpc_id(1)


func _on_btn_unirse_pressed() -> void:
	Eventos.singleplayer = false
	Eventos.multiOnline = true
	MultiplayerControl.address = $BtnUnirse/LineEditJoin.text
	var code = "fc" + MultiplayerControl.address.replace("Z",":").to_lower()
	MultiplayerControl.isHost = false
	Names.generar_nombres()
	MultiplayerControl.peer = await GotmMultiplayer.create_client(code)
	MultiplayerControl.multiplayer.multiplayer_peer = MultiplayerControl.peer
	MultiplayerControl.multiplayer.connected_to_server.connect(func(): print("connected!"))
	MultiplayerControl.multiplayer.connection_failed.connect(func(): print("connection failed"))
	await MultiplayerControl.multiplayer.connected_to_server
	loaded_peer.rpc_id(1)


var cantidadPeer = 0
@rpc("any_peer", "call_local", "reliable")
func loaded_peer():
	if multiplayer.is_server():
		cantidadPeer += 1
	if cantidadPeer == 2:
		init_multi.rpc()
		
@rpc("authority","call_local","unreliable")
func init_multi():
	get_tree().change_scene_to_file("res://Escenas/Maingame/Maingame.tscn")


func _on_btn_copy_to_clip_board_pressed() -> void:
	DisplayServer.clipboard_set($LineAddressCopy.text)


func _on_btn_paste_clip_board_pressed() -> void:
	var current_clipboard = DisplayServer.clipboard_get()
	$BtnUnirse/LineEditJoin.text = current_clipboard
