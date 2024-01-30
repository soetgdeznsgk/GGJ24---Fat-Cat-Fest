extends Control
@onready var nombreGato1 = Names.name_player1
@onready var nombreGato2 = Names.name_player2
@onready var soundQueue = []
@onready var switch = false
@onready var sfxVS := preload("res://SFX/Narrador/vs1.mp3")
var bg_music_versus:= AudioStreamPlayer.new()
func _ready():
	bg_music_versus.stream = load("res://Musica/tfcf_vs.mp3")
	bg_music_versus.autoplay = true
	bg_music_versus.bus = "Music"
	add_child(bg_music_versus)
	$Gato1.get_child(0).play("Idle")
	$Gato2.get_child(0).play("Idle")
	$Gato1.get_child(1).set_text(nombreGato1)
	$Gato1.get_child(1).modulate = Color("#88D662")
	$Gato2.get_child(1).set_text(nombreGato2)
	$Gato2.get_child(1).modulate = Color("#F2DF6F")
	soundQueue.append(load(Names.dirAudioInitial1))
	soundQueue.append(load(Names.dirAudioFinal1))
	soundQueue.append(sfxVS)
	soundQueue.append(load(Names.dirAudioInitial2))
	soundQueue.append(load(Names.dirAudioFinal2))
	$AudioPlayer.stream = soundQueue.pop_front()
	$AudioPlayer.play()


func _on_audio_player_finished():
	var currentSound = soundQueue.pop_front()
	if !currentSound:
		if Eventos.singleplayer && !Eventos.tutorialSingleplayerHecho:
			get_tree().change_scene_to_file("res://Escenas/Maingame/TutorialSingleplayer.tscn")
		elif !Eventos.singleplayer && !Eventos.tutorialMultiplayerHecho:
			get_tree().change_scene_to_file("res://Escenas/Maingame/TutorialMultiplayer.tscn")
		else:
			get_tree().change_scene_to_file("res://Escenas/Maingame/Maingame.tscn")
			
	$AudioPlayer.stream = currentSound
	$AudioPlayer.play()
		
