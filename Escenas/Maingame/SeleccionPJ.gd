extends Node2D

var listaGatos = ["Miguel", "Timmy"]
var diccionarioInputs := {}
# Called when the node enters the scene tree for the first time.
func _ready():
	if Eventos.singleplayer or Eventos.multiOnline:
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
	elif !Eventos.singleplayer and !Eventos.multiOnline:
#region INPUT BOTONES
		var key = InputEventKey.new()
		key = InputEventKey.new()
		key.keycode = KEY_LEFT
		InputMap.action_erase_event("IzquierdaPj1",key)
		key = InputEventKey.new()
		key.keycode = KEY_RIGHT
		InputMap.action_erase_event("DerechaPj1",key)
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
		
	if !Eventos.multiOnline:
	# Dependiendo del jugador tiene ciertas teclas para el physic process
		diccionarioInputs[Enums.Arriba] = "ArribaPj" + str(jugador)
		diccionarioInputs[Enums.Abajo]  = "AbajoPj" + str(jugador)
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj" + str(jugador)
		diccionarioInputs[Enums.Derecha] = "DerechaPj" + str(jugador)
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1" 
		diccionarioInputs[Enums.Abajo]  = "AbajoPj1" 
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj1" 
		diccionarioInputs[Enums.Derecha] = "DerechaPj1"
		
func _input(event):
	if event is InputEventKey:
		Globals.mouseToggle = false

	elif event is InputEventMouseMotion:
		if(Globals.mouseInNode and Globals.focusedNode):
			Globals.mouseToggle = true
			Globals.focusedNode.grab_focus()
	if Eventos.singleplayer or Eventos.multiOnline:
		if 
	pass
