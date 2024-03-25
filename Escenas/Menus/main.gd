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

var displayedMsgs   = []


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
	get_tree().change_scene_to_file("res://Escenas/Maingame/SeleccionPj.tscn")

func _on_medium_btn_pressed():
	Eventos.singleplayer = true
	Eventos.cpuDiff = 2
	Names.generar_nombres()
	Names.name_player2 += " (CPU)"
	get_tree().change_scene_to_file("res://Escenas/Maingame/SeleccionPj.tscn")
	
func _on_hard_btn_pressed():
	Eventos.singleplayer = true
	Eventos.cpuDiff = 3
	Names.generar_nombres()
	Names.name_player2 += " (CPU)"
	get_tree().change_scene_to_file("res://Escenas/Maingame/SeleccionPj.tscn")

func _on_mp_btn_pressed(): 
	Eventos.singleplayer = false
	Names.generar_nombres()
	get_tree().change_scene_to_file("res://Escenas/Maingame/SeleccionPj.tscn")
	
func _on_ol_btn_pressed(): 
	bocadillo.displayText({"text" : "Soon™", "time" : 3.0, "fontSize": 28 })

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
	bocadillo.displayText({"text" : "Copied!", "time":3})
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

func _on_info_btn_pressed(): 
	bocadillo.visible = false
	animP.play("slideInCredits")
	
func _on_credits_path_back_pressed(): 
	animP.play("slideOutCredits")
	
func randomFuniMsg():
	
	var msgs = [
	{ "text": "tengo hambre we", "time": 1.0, "fontSize": 28 },
	{ "text": "a pero si fuera yuli", "time": 1.0, "fontSize": 28 },
	{ "text": "inside joke #3", "time": 1.0, "fontSize": 28 },
	{ "text": ":3", "time": 5.0, "fontSize": 90 },
	{ "text": "Dos de carne, cuatro de choclo, cinco de carne, una de choclo, nueve de carne, siete de choclo, cinco de choclo, cinco de carne, cinco de choclo, cinco de choclo, cinco de choclo, una de choclo, dos de choclo, cinco de choclo", "time": 3.0, "fontSize": 12 },
	{ "text": "UN SALUDO A LA GRASAAAAAAAAAAAAAAAAA", "time": 2.0, "fontSize": 28 },
	{ "text": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH!", "time": 2.0, "fontSize": 20 },
	{ "text": "ඞ", "time": 0.5, "fontSize": 90 },
	{ "text": "I povited", "time": 1.0, "fontSize": 28 },
	{ "text": "Eating a burguer with no honey mustard", "time": 2.0, "fontSize": 28 },
	{ "text": "The legend of buñuelo png", "time": 2.0, "fontSize": 28 },
	{ "text": "papa y katsup y no' fuimo", "time": 2.0, "fontSize": 28 },
	{ "text": "un video más mi gente pa perder el tiempo", "time": 2.0, "fontSize": 28 },
	{ "text": "War. War never changes", "time": 2.0, "fontSize": 28 },
	{ "text": "couldn't reach the quota :c", "time": 2.0, "fontSize": 28 },
	{ "text": "Cuando no como me da hambre", "time": 2.0, "fontSize": 28 },
	{ "text": "Skibidi fortnite", "time": 1.0, "fontSize": 28 },
	{ "text": "Masenko haa", "time": 1.0, "fontSize": 28 },
	{ "text": "Also try Minecraft!", "time": 1.0, "fontSize": 28 },
	{ "text": "Also try Gem Frenzy!", "time": 1.0, "fontSize": 28 },
	{ "text": "Fat Cat Fest: Repentance", "time": 3.0, "fontSize": 28 },
	{ "text": "Who am I?", "time": 5.0, "fontSize": 28 },
	{ "text": "mañana sale silksong mañana sale silksong mañana sale silksong mañana sale silksong mañana sale silksong mañana sale silksong mañana sale silksong mañana sale silksong mañana sale silksong mañana sale silksong mañana sale silksong mañana sale silksong", "time": 1.0, "fontSize": 12 },
	{ "text": "\"A terrifying presence has entered the room...\"", "time": 2.0, "fontSize": 29 },
	{ "text": "Papu despierta, tienes que hornear unos momazos", "time": 2.0, "fontSize": 28 }
	]

	if displayedMsgs.size() == msgs.size():
		displayedMsgs.clear()

	# Choose a random message from the list of undisplayed messages
	var undisplayedMsgs = msgs.filter(func(msg) -> bool:
		return msg not in displayedMsgs
	)
	
	var randomMsg = undisplayedMsgs[randi() % undisplayedMsgs.size()]
	displayedMsgs.append(randomMsg)

	# Display the message
	bocadillo.displayText(randomMsg)
