extends Node2D

@onready var paths = {
	"mainPath" : {
		"container" : $MainOptPath,
		"focusBtns" : {
			"top" : $MainOptPath/playBtn ,
			"low" : $MainOptPath/infoBtn
		}
	},
	"playPath" : {
		"container" : $PlayPath,
		"focusBtns" : {
			"top" : $PlayPath/SPBtn,
			"low" : $PlayPath/playPathBack
		}
	},
	"OnlinePath" : {
		"container" : $OLConfig,
		"focusBtns" : {
			"top" : $OLConfig/HostOptions/CreateBtn,
			"low" : $OLConfig/onlinePathBack}
	},
	"OptionsPath" : {
		"container" : $OptionsPath,
		"focusBtns" : {
			"top" : $OptionsPath/masterVolSlider/muteBtn,
			"low" : $OptionsPath/optionsPathBack}
	},
	"CreditsPath" : {
		"container" : $CreditsPath,
		"focusBtns" : {
			"top" : $CreditsPath/HBoxContainer/specialBtn,
			"low" : $CreditsPath/HBoxContainer/creditsPathBack}
	},
}

@onready var SPBtn = $PlayPath/SPBtn
@onready var diffSelector = $PlayPath/DiffSelector
@onready var ezBtn = $PlayPath/DiffSelector/EasyBtn
@onready var mediumBtn = $PlayPath/DiffSelector/MediumBtn
@onready var hardBtn = $PlayPath/DiffSelector/HardBtn

@onready var onlineBtn = $PlayPath/HBoxContainer/OLBtn
@onready var copyCodeLabel = $OLConfig/HostOptions/CopyCode
@onready var pasteCodeLabel = $OLConfig/PeerOptions/PasteCode

@onready var animP = $AnimationPlayer
@onready var gatoTragon = $gatoTragon
@onready var bocadillo = $Bocadillo

var vp : Viewport
var currentPath = null
var topBtn : Control 
var botBtn : Control


# Called when the node enters the scene tree for the first time.
func _ready():
	vp = get_viewport()
	vp.connect("gui_focus_changed",_focus_change)
	change_path("mainPath")

func change_path(path : String):
	currentPath = path
	for key in paths.keys():
		#Toggle visibility
		paths[key]["container"].visible = (key == path)
	topBtn = paths[path]["focusBtns"]["top"]
	botBtn = paths[path]["focusBtns"]["low"]
	
	#Automatic retoggle if using keyboard
	if (!Globals.mouseToggle): topBtn.grab_focus()

func _input(event):
	# Check if the event is a keyboard event
	if event is InputEventKey:
		Globals.mouseToggle = false

	elif event is InputEventMouseMotion:
		if(Globals.mouseInNode and Globals.focusedNode):
			Globals.mouseToggle = true
			Globals.focusedNode.grab_focus()
	
	if Input.is_action_just_pressed("ui_up") and !vp.gui_get_focus_owner():
		topBtn.grab_focus()
		
	if Input.is_action_just_pressed("ui_down") and !vp.gui_get_focus_owner():
		botBtn.grab_focus()
		
	if Input.is_action_just_pressed("ui_cancel"):
		
		if currentPath == "playPath":
			if diffSelector.is_visible():
				SPBtn.visible = true
				diffSelector.visible = false
				topBtn = SPBtn
				SPBtn.grab_focus()
			else: 
				change_path("mainPath")
		
		if currentPath == "OptionsPath":
			change_path("mainPath")
			

func _focus_change(control : Control):
	# playPath
	if diffSelector.is_visible() and control not in [ezBtn,mediumBtn,hardBtn]:
		diffSelector.visible = false
		SPBtn.visible = true
		topBtn = SPBtn


#region Play path buttons
func _on_play_btn_pressed(): change_path("playPath")

func _on_sp_btn_pressed():
	SPBtn.visible = false
	diffSelector.visible = true
	topBtn = ezBtn
	topBtn.grab_focus()

func _on_easy_btn_pressed(): 
	Eventos.singleplayer = true
	Eventos.cpuDiff = 1
	Names.generar_nombres()
	Names.name_player2 += " (CPU)"
	get_tree().change_scene_to_file("res://Escenas/Maingame/Versus.tscn")

func _on_medium_btn_pressed():
	Eventos.singleplayer = true
	Eventos.cpuDiff = 2
	Names.generar_nombres()
	Names.name_player2 += " (CPU)"
	get_tree().change_scene_to_file("res://Escenas/Maingame/Versus.tscn")
	
func _on_hard_btn_pressed():
	Eventos.singleplayer = true
	Eventos.cpuDiff = 3
	Names.generar_nombres()
	Names.name_player2 += " (CPU)"
	get_tree().change_scene_to_file("res://Escenas/Maingame/Versus.tscn")

func _on_mp_btn_pressed(): 
	Eventos.singleplayer = false
	Names.generar_nombres()
	get_tree().change_scene_to_file("res://Escenas/Maingame/Versus.tscn")
	
func _on_ol_btn_pressed(): change_path("OnlinePath")

func _on_create_btn_pressed(): 
	$OLConfig/HostOptions/CreateBtn.disabled = true
	Eventos.singleplayer = false
	Eventos.multiOnline = true
	MultiplayerControl.isHost = true
	MultiplayerControl.peer  = await GotmMultiplayer.create_server()
	MultiplayerControl.multiplayer.multiplayer_peer = MultiplayerControl.peer
	MultiplayerControl.multiplayer.peer_connected.connect(func(id): MultiplayerControl.clientId = id)
	# Players can join using this address.
	MultiplayerControl.address = await GotmMultiplayer.get_address()
	
	# Bobada de remplazar sstrings para que no parezca una IP
	var code = MultiplayerControl.address.replace(":","Z").to_upper().substr(2,-1)
	copyCodeLabel.text = code
	DisplayServer.clipboard_set(code)
	#TODO: Coso mostrar que se copió el código ya
	loaded_peer.rpc_id(1)

var cantidadPeer = 0
@rpc("any_peer", "call_local", "reliable")
func loaded_peer():
	if multiplayer.is_server():
		cantidadPeer += 1
	if cantidadPeer == 2:
		Names.generar_nombres()
		init_multi.rpc()

@rpc("authority","call_local","unreliable")
func init_multi():
	get_tree().change_scene_to_file("res://Escenas/Maingame/Versus.tscn")

func _on_join_btn_pressed():
	$OLConfig/PeerOptions/JoinBtn.disabled = true
	Eventos.singleplayer = false
	Eventos.multiOnline = true
	MultiplayerControl.address = pasteCodeLabel.text
	var code = "fc" + MultiplayerControl.address.replace("Z",":").to_lower()
	#TODO: esta mierda tiene validación? xd
	MultiplayerControl.isHost = false
	MultiplayerControl.peer = await GotmMultiplayer.create_client(code)
	MultiplayerControl.multiplayer.multiplayer_peer = MultiplayerControl.peer
	MultiplayerControl.multiplayer.connected_to_server.connect(func(): print("connected!"))
	MultiplayerControl.multiplayer.connection_failed.connect(func(): $VBoxContainer2/HBoxContainer/VBoxContainer2/BtnUnirse.disabled = false)
	await MultiplayerControl.multiplayer.connected_to_server
	loaded_peer.rpc_id(1)
	
func _on_online_path_back_pressed(): change_path("playPath")
func _on_play_path_back_pressed(): change_path("mainPath")

#endregion

func _on_options_btn_pressed(): change_path("OptionsPath")
func _on_options_path_back_pressed(): change_path("mainPath")

func _on_info_btn_pressed(): animP.play("slideInCredits")
func _on_credits_path_back_pressed(): 
	animP.play("slideOutCredits")
	
func randomFuniMsg():
		bocadillo.displayText(
		[
			["tengo hambre we",1],
			["a pero si fuera yuli",1],
			["inside joke #3", 1],
			["miaw :3", 1 ],
			["dame 2 d carne 4 de choclo 5 de carne 1 de choclo 5 de choclo 5 de choclo ",3],
			["UN SALUDO A LA GRASAAAAAAAAAAAAAAAAA", 2],
			["AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", 2],
			["ඞ" , 0.5],
			["I povited", 1],
			["Eating a burguer with no honey mustard", 2],
			["The legend of buñuelo png", 1],
			["papa y katsup y no' fuimo", 1],
			["un video más mi gente pa perder el tiempo", 1],
			["War. War never changes", 1],
			["couldn´t reach the quota :c", 1],
		].pick_random())

