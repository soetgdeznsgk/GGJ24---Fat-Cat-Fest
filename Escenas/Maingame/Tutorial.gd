extends Node2D

@onready var animP = $AnimationPlayer
@onready var sprPantalla = $pantalla
var mainGame = preload("res://Escenas/Maingame/Maingame.tscn")

func _ready():
	sprPantalla.play("SinglePlayer" if Eventos.singleplayer else "MultiPlayer")
	
# Estas cosas se llaman desde el animation player
func pasandoaltutorial(): animP.play("eneltutorial")
func pasandoalfinal(): animP.play("adios_tutorialprogamer")
func fintutorial(): get_tree().change_scene_to_packed(mainGame)
