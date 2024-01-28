extends Control
@onready var nombreGato1 = Names.name_player1
@onready var nombreGato2 = Names.name_player2
@onready var soundQueue = []
@onready var switch = false
@onready var sfxVS := preload("res://SFX/Narrador/vs1.mp3")

func _ready():
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
		get_tree().change_scene_to_file("res://Escenas/Maingame/Tutorial.tscn")
	$AudioPlayer.stream = currentSound
	$AudioPlayer.play()

func _on_animated_sprite_2d_frame_changed():
	print ("augh")
	if switch:
		$Gato1/AnimatedSprite2D.set_scale(Vector2(-0.6, 0.6))
		switch = true
	else:
		$Gato1/AnimatedSprite2D.set_scale(Vector2(0.6, 0.6))
		switch = false
		
