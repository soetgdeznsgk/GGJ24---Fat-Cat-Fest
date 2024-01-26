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
	Eventos.ganadorFestival.connect(finJuego)

func finJuego(ganador):
	$Comandos.procesosPausados =true
	$Comandos2.procesosPausados =true
	Eventos.ganador = ganador
	await get_tree().create_timer(2.7).timeout
	$GatosPublico.queue_free()
	$Comandos2.queue_free()
	$Comandos.queue_free()
	get_tree().change_scene_to_file("res://Escenas/escenario_ganador.tscn")
	
