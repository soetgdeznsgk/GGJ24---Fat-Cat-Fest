extends Node2D

func _ready() -> void:
	if Eventos.singleplayer:
		var bot = preload("res://Logica/cpu_jugador.tscn").instantiate()
		add_child(bot)
#region INPUT BOTONES
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
#endregion
	else:
#region INPUT BOTONES
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
		key = InputEventJoypadMotion.new()
		key.axis = JOY_AXIS_LEFT_Y
		key.device = 1
		key.axis_value = -1
		InputMap.action_add_event("ArribaPj2",key)
		key = InputEventJoypadMotion.new()
		key.axis = JOY_AXIS_LEFT_Y
		key.device = 1
		key.axis_value = 1
		InputMap.action_add_event("AbajoPj2",key)
		key = InputEventJoypadMotion.new()
		key.axis = JOY_AXIS_LEFT_X
		key.device = 1
		key.axis_value = -1
		InputMap.action_add_event("IzquierdaPj2",key)
		key = InputEventJoypadMotion.new()
		key.axis = JOY_AXIS_LEFT_X
		key.device = 1
		key.axis_value = 1
		InputMap.action_add_event("DerechaPj2",key)
		key = InputEventJoypadButton.new()
		key.device = 1
		key.button_index = JOY_BUTTON_DPAD_UP
		InputMap.action_add_event("ArribaPj2",key)
		key = InputEventJoypadButton.new()
		key.device = 1
		key.button_index = JOY_BUTTON_DPAD_DOWN
		InputMap.action_add_event("AbajoPj2",key)
		key = InputEventJoypadButton.new()
		key.device = 1
		key.button_index = JOY_BUTTON_DPAD_LEFT
		InputMap.action_add_event("IzquierdaPj2",key)
		key = InputEventJoypadButton.new()
		key.device = 1
		key.button_index = JOY_BUTTON_DPAD_RIGHT
		InputMap.action_add_event("DerechaPj2",key)
		
#endregion
		
		# en caso de que se ejecute luego de una partida SP, reestablecer las acciones de Pj1
		pass
	Eventos.ganadorFestival.connect(finJuego)

func finJuego(ganador):
	$Comandos.procesosPausados =true
	$Comandos2.procesosPausados =true
	Eventos.ganador = ganador
	if Eventos.singleplayer:
		get_node("CPUJugador").queue_free()
	$Comandos2.queue_free()
	$Comandos.queue_free()
	$comidas.queue_free()
	$Mesa.queue_free()
	$Sillas.queue_free()
	$Cartel.queue_free()
	$Stage.queue_free()
	$Deco.queue_free()
	$Fondo.queue_free()
	await get_tree().create_timer(2.2).timeout
	var scn = load("res://Escenas/escenario_ganador.tscn")
	get_parent().add_child(scn.instantiate())
	$QuickTimeEvent.queue_free()
	
