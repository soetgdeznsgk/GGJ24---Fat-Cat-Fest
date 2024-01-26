extends Node2D

func _ready() -> void:
	if Eventos.singleplayer:
		var bot = preload("res://Logica/cpu_jugador.tscn").instantiate()
		add_child(bot)
		InputMap.action_erase_events("ArribaPj1") 
		InputMap.action_erase_events("AbajoPj1")
		InputMap.action_erase_events("IzquierdaPj1")
		InputMap.action_erase_events("DerechaPj1")
	else:
		# en caso de que se ejecute luego de una partida SP, reestablecer las acciones de Pj1
		pass
