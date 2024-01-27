extends Control
@onready var nombreGato1 = Names.name_player1
@onready var nombreGato2 = Names.name_player2

func _ready():
	$Gato1.play("Idle")
	$Gato2.play("Idle")
	$NombreGato1.set_text(nombreGato1)
	$NombreGato2.set_text(nombreGato2)

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Escenas/Maingame/Maingame.tscn")
