extends Control
@onready var nombreGato1 = Names.name_player1
@onready var nombreGato2 = Names.name_player2
@onready var soundQueue = []
@onready var sfxVS := preload("res://SFX/Narrador/vs1.mp3")

func _ready():
	$Gato1.get_child(0).play("Idle")
	$Gato2.get_child(0).play("Idle")
	$Gato1.get_child(1).set_text(nombreGato1)
	$Gato2.get_child(1).set_text(nombreGato2)
	soundQueue.append(load(Names.dirAudioInitial1))
	soundQueue.append(load(Names.dirAudioFinal1))
	soundQueue.append(sfxVS)
	soundQueue.append(load(Names.dirAudioInitial2))
	soundQueue.append(load(Names.dirAudioFinal2))
	
	$AudioStreamPlayer.stream = soundQueue.pop_front()
	$AudioStreamPlayer.play()

func _on_audio_stream_player_finished():
	if soundQueue.front() == null:
		get_tree().change_scene_to_file("res://Escenas/Maingame/Maingame.tscn")
	$AudioStreamPlayer.stream = soundQueue.pop_front()
	$AudioStreamPlayer.play()	
	
