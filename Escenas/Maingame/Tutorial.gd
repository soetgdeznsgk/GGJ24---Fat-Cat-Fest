extends Node2D

@onready var animP = $AnimationPlayer
@onready var sprPantalla = $pantalla
var mainGame = preload("res://Escenas/Maingame/Maingame.tscn")

func _ready():
	if (!Eventos.tutorialSingleplayerHecho && Eventos.singleplayer):
		sprPantalla.play("SinglePlayer")
		Eventos.tutorialSingleplayerHecho = true
	elif (!Eventos.tutorialMultiplayerHecho && !Eventos.singleplayer):
		sprPantalla.play("MultiPlayer")
		Eventos.tutorialMultiplayerHecho = true
	else: transicionSinTutorial()
	
# Estas cosas se llaman desde el animation player
func pasandoaltutorial():
	animP.play("eneltutorial")
func pasandoalfinal():
	animP.play("adios_tutorialprogamer")
func transicionSinTutorial():
	animP.play("transicion_sin_tutorial")

func fintutorial(): get_tree().change_scene_to_packed(mainGame)
