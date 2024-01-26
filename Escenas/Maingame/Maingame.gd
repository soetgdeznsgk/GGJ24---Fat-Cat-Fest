extends Node2D

func _ready() -> void:
	if Eventos.singleplayer:
		var bot = preload("res://Logica/cpu_jugador.tscn").instantiate()
		add_child(bot)
