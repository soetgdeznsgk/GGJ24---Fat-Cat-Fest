extends Control
@onready var nombreGato1 = Names.name_player1
@onready var nombreGato2 = Names.name_player2
@onready var sfxNombreInicial1 := AudioStreamPlayer.new()
@onready var sfxNombreFinal1 := AudioStreamPlayer.new()
@onready var sfxNombreInicial2 := AudioStreamPlayer.new()
@onready var sfxNombreFinal2 := AudioStreamPlayer.new()
@onready var vsPlayer = AudioStreamPlayer.new()
@onready var sfxVS := [preload("res://SFX/Narrador/vs1.mp3")]

func _ready():
	$Gato1.get_child(0).play("Idle")
	$Gato2.get_child(0).play("Idle")
	$Gato1.get_child(1).set_text(nombreGato1)
	$Gato2.get_child(1).set_text(nombreGato2)
	sfxNombreInicial1.stream = load(Names.dirAudioInitial1)
	sfxNombreFinal1.stream = load(Names.dirAudioFinal1)
	sfxNombreInicial2.stream = load(Names.dirAudioInitial2)
	sfxNombreFinal2.stream = load(Names.dirAudioFinal2)
	vsPlayer.stream = sfxVS.pick_random()
	vsPlayer.bus = "SFX"
	sfxNombreInicial1.bus = "SFX"
	sfxNombreFinal1.bus = "SFX"
	sfxNombreInicial2.bus = "SFX"
	sfxNombreFinal2.bus = "SFX"
	
	add_child(vsPlayer)
	add_child(sfxNombreInicial1)
	add_child(sfxNombreFinal1)
	add_child(sfxNombreInicial2)
	add_child(sfxNombreFinal2)
	sfxNombreInicial1.finished.connect(_on_NombreInicial1_finished)
	sfxNombreFinal1.finished.connect(_on_NombreFinal1_finished)
	vsPlayer.finished.connect(_on_sfxVS_finished)
	sfxNombreInicial2.finished.connect(_on_NombreInicial2_finished)
	sfxNombreFinal2.finished.connect(_on_NombreFinal2_finished)
	
	print("audios")
	sfxNombreInicial1.play()
	
func _on_NombreInicial1_finished():
	sfxNombreFinal1.play()

func _on_NombreFinal1_finished():
	vsPlayer.play()

func _on_sfxVS_finished():
	sfxNombreInicial2.play()
	
func _on_NombreInicial2_finished():
	sfxNombreFinal2.play()

func _on_NombreFinal2_finished():
	get_tree().change_scene_to_file("res://Escenas/Maingame/Maingame.tscn")
