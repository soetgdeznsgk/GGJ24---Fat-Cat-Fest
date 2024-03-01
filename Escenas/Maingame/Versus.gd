extends Control

@onready var gato1 = $Gato1
@onready var gato2 = $Gato2
@onready var labelgato1 = $NombreGato1
@onready var labelgato2 = $NombreGato2

var nombreGato1 = Names.name_player1
var nombreGato2 = Names.name_player2
var soundQueue = []
var switch = false

@onready var animP = $ControlTelon

func _ready():
	var resourcesp1 = RecursosGatos.recursos[RecursosGatos.catSelectionP1]["versusScreen"]
	var resourcesp2 = RecursosGatos.recursos[RecursosGatos.catSelectionP2]["versusScreen"]
	
	gato1.sprite_frames = resourcesp1["anims"]
	gato1.position = resourcesp1["posLeft"]
	gato1.scale = resourcesp1["scale"]
	
	gato2.sprite_frames = resourcesp2["anims"]
	gato2.position = resourcesp2["posRight"]
	gato2.scale = resourcesp2["scale"]
	
	gato1.play("Idle")
	gato2.play("Idle")
	
	labelgato1.text = Names.name_player1
	labelgato2.text = Names.name_player2
	
	soundQueue.append(load(Names.dirAudioInitial1))
	soundQueue.append(load(Names.dirAudioFinal1))
	soundQueue.append(load("res://SFX/Narrador/vs1.mp3"))
	soundQueue.append(load(Names.dirAudioInitial2))
	soundQueue.append(load(Names.dirAudioFinal2))
	$AudioPlayer.stream = soundQueue.pop_front()
	$AudioPlayer.play()

func _on_audio_player_finished():
	var currentSound = soundQueue.pop_front()
	if !currentSound: animP.play("BajarTelon")
	$AudioPlayer.stream = currentSound
	$AudioPlayer.play()
	
func _goToGame():
	get_tree().change_scene_to_file("res://Escenas/Maingame/Tutorial.tscn")
	

