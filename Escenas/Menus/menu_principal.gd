extends Control

var isDeveloped := false
var bg_music := AudioStreamPlayer.new()
var noMouse = false
var mousePos : Vector2
@onready var gatoGif = $MenuPrincipal/HBoxContainer/CenterContainer/GatoGif
@onready var button_standard_audio := AudioStreamPlayer.new()
@onready var return_button_audio := AudioStreamPlayer.new()

var root
func _enter_tree():
	root = get_tree().get_root()

# Called when the node enters the scene tree for the first time.
func _ready():
	bg_music.stream = load("res://Musica/tfcf_menu_v2.wav")
	bg_music.autoplay = true
	bg_music.bus = "Music"
	add_child(bg_music)
	button_standard_audio.bus = "SFX"
	return_button_audio.bus = "SFX"
	button_standard_audio.stream = load("res://Escenas/Menus/sfx/button_standard.wav")
	return_button_audio.stream = load("res://Escenas/Menus/sfx/back_button_sfx.wav")
	add_child(button_standard_audio)
	add_child(return_button_audio)
	
	gatoGif.play("Eat")

func deviceChanged():
	if noMouse:
		if !isDeveloped: # menu principal
			$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.showPlayButton()
			$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.PlayButton.grab_focus()
		elif $MenuPrincipal/HBoxContainer/VBoxContainer/ContenedorOpciones.visible: #menu config
			$MenuPrincipal/HBoxContainer/VBoxContainer/ContenedorOpciones/OptionsVBoxContainer/MusicVolumeSlider.grab_focus()
		else: # creditos
			$MenuPrincipal/HBoxContainer/VBoxContainer/CreditsContainer/CreditsVBox/HBoxContainer2/HBoxContainer/BackButton.grab_focus()
	else:
		$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.PlayButton.release_focus()
		$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.SPButton.release_focus()
		$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.MPButton.release_focus()
		%OptionsButton.release_focus()
		%CreditsButton.release_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and isDeveloped:
		_undevelop_menu()
		$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.PlayButton.grab_focus()

	if Input.is_action_just_pressed("AbajoPj1") and !noMouse:
		noMouse = true
		deviceChanged()
		mousePos = get_global_mouse_position()
	if Input.is_action_just_pressed("ArribaPj1") and !noMouse:
		noMouse = true
		deviceChanged()
		mousePos = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and noMouse:
		noMouse = false
		deviceChanged()
	if mousePos.distance_squared_to(get_global_mouse_position()) > 200 and noMouse:
		noMouse = false
		deviceChanged()
	if (%OptionsButton.has_focus() or %CreditsButton.has_focus()) and $MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.isDeveloped:
		$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.showPlayButton()


func _undevelop_menu():
	return_button_audio.play()
	isDeveloped = false

	$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer.show()
	$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.showPlayButton()
	$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer/HBoxContainer.PlayButton.grab_focus()
	$MenuPrincipal/HBoxContainer/VBoxContainer/ContenedorOpciones.hide()
	$MenuPrincipal/HBoxContainer/VBoxContainer/CreditsContainer.hide()
	# esconder creditos también

func _on_option_button_pressed():
	isDeveloped = true
	button_standard_audio.play()
	$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer.hide()
	$MenuPrincipal/HBoxContainer/VBoxContainer/ContenedorOpciones.show()
	$MenuPrincipal/HBoxContainer/VBoxContainer/ContenedorOpciones/OptionsVBoxContainer/MusicVolumeSlider.grab_focus()



func _on_h_box_container_mp_start_game(): # iniciar juego mp
	button_standard_audio.play()
	Eventos.singleplayer = false
	Names.generar_nombres()
	get_tree().change_scene_to_file("res://Escenas/Maingame/Versus.tscn")

func _on_h_box_container_sp_start_game(): # iniciar juego sp
	button_standard_audio.play()
	Eventos.singleplayer = true
	Names.generar_nombres()	
	get_tree().change_scene_to_file("res://Escenas/Maingame/Versus.tscn")
	Names.name_player2 += " (CPU)"


func _on_credits_button_pressed() -> void:
	button_standard_audio.play()
	$MenuPrincipal/HBoxContainer/VBoxContainer/CreditsContainer/CreditsVBox/HBoxContainer2/HBoxContainer/BackButton.grab_focus()
	isDeveloped = true
	$MenuPrincipal/HBoxContainer/VBoxContainer/MainVBoxContainer.hide()
	$MenuPrincipal/HBoxContainer/VBoxContainer/CreditsContainer.show()


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
	print(MultiplayerControl.address)
	$MultiOrLocal/BtnUnirse/LineEdit2.text = MultiplayerControl.address
	loaded_peer.rpc_id(1)
	
	#var lobby_name = "My lobby"
	#var lobby: GotmLobby = await GotmLobby.create(lobby_name)


func _on_btn_unirse_pressed() -> void:
	Eventos.singleplayer = false
	Eventos.multiOnline = true
	MultiplayerControl.address = $MultiOrLocal/BtnUnirse/LineEdit.text
	MultiplayerControl.isHost = false
	Names.generar_nombres()
	MultiplayerControl.peer = await GotmMultiplayer.create_client(MultiplayerControl.address)
	MultiplayerControl.multiplayer.multiplayer_peer = MultiplayerControl.peer
	MultiplayerControl.multiplayer.connected_to_server.connect(func(): print("connected!"))
	MultiplayerControl.multiplayer.connection_failed.connect(func(): print("connection failed"))

	await MultiplayerControl.multiplayer.connected_to_server
	loaded_peer.rpc_id(1)
	#MultiplayerControl.peer.put_var("initiate game")
	
	#var lobbies: Array = await GotmLobby.list()
	#if !lobbies:
		#print("no lobbies found")
		#return
	#var address: String = lobbies[0].address
	#print(lobbies)

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
