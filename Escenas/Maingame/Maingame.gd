extends Node2D

func _ready() -> void:
	if Eventos.singleplayer:
		var bot = preload("res://Logica/cpu_jugador.tscn").instantiate()
		add_child(bot)
		InputMap.action_erase_events("ArribaPj2") 
		InputMap.action_erase_events("AbajoPj2")
		InputMap.action_erase_events("IzquierdaPj2")
		InputMap.action_erase_events("DerechaPj2")
		var key = InputEventKey.new()
		key.keycode = KEY_UP
		InputMap.action_add_event("ArribaPj1",key)
		key = InputEventKey.new()
		key.keycode = KEY_DOWN
		InputMap.action_add_event("AbajoPj1",key)
		key = InputEventKey.new()
		key.keycode = KEY_LEFT
		InputMap.action_add_event("IzquierdaPj1",key)
		key = InputEventKey.new()
		key.keycode = KEY_RIGHT
		InputMap.action_add_event("DerechaPj1",key)
	else:
		var key = InputEventKey.new()
		key.keycode = KEY_UP
		InputMap.action_erase_event("ArribaPj1",key)
		key = InputEventKey.new()
		key.keycode = KEY_DOWN
		InputMap.action_erase_event("AbajoPj1",key)
		key = InputEventKey.new()
		key.keycode = KEY_LEFT
		InputMap.action_erase_event("IzquierdaPj1",key)
		key = InputEventKey.new()
		key.keycode = KEY_RIGHT
		InputMap.action_erase_event("DerechaPj1",key)
		key = InputEventKey.new()
		key.keycode = KEY_UP
		InputMap.action_add_event("ArribaPj2",key)
		key = InputEventKey.new()
		key.keycode = KEY_DOWN
		InputMap.action_add_event("AbajoPj2",key)
		key = InputEventKey.new()
		key.keycode = KEY_LEFT
		InputMap.action_add_event("IzquierdaPj2",key)
		key = InputEventKey.new()
		key.keycode = KEY_RIGHT
		InputMap.action_add_event("DerechaPj2",key)
		# TODO AGREGAR LOS CONTROLES JOYSTICK DE NUEVO A PJ2
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
	
