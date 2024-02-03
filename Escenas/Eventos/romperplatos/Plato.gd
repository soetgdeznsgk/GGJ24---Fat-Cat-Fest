extends Area2D

var vida = 3
@export var jugador = 2
var diccionarioInputs := {}
@onready var anim = $AnimationPlayer
@export var speed : int = 100
var canMove = true
var vectorVelocidad = Vector2.ZERO

func _ready() -> void:
	Eventos.enviarVector.connect(recibir_nuevo_input)

func recibir_nuevo_input(vector, jugadorARecibir):
	if jugador == jugadorARecibir:
		vectorVelocidad = vector
	
func cambiar_rol():
	vida = 3
	$Sprite2D2.texture = \
	load("res://Sprites/QuickTimeEvent/brazoplapj1-1.png") \
	if jugador==1 else \
	load("res://Sprites/QuickTimeEvent/brazoplapj2-1.png")
	
	if jugador == 2:
		if !Eventos.multiOnline:
			diccionarioInputs[Enums.Arriba] = "ArribaPj2"
			diccionarioInputs[Enums.Abajo] = "AbajoPj2"
			diccionarioInputs[Enums.Izquierda] = "IzquierdaPj2"
			diccionarioInputs[Enums.Derecha] = "DerechaPj2"
		else:
			diccionarioInputs[Enums.Arriba] = "ArribaPj1"
			diccionarioInputs[Enums.Abajo]  = "AbajoPj1"
			diccionarioInputs[Enums.Izquierda] = "IzquierdaPj1"
			diccionarioInputs[Enums.Derecha] = "DerechaPj1"
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj1"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj1"
		diccionarioInputs[Enums.Derecha] = "DerechaPj1"
		$Label.text = Names.name_player1
		$Label.modulate = Color("#88D662")

func _physics_process(delta: float) -> void:
	if !canMove:
		return
	
	if position.y < 160:
		position.y = 160
	if position.y > 620:
		position.y = 620
	if position.x < 160:
		position.x = 160
	if position.x > 1220:
		position.x = 1220
		
	if !Eventos.multiOnline or (multiplayer.is_server() and jugador == 1) or (!multiplayer.is_server() and jugador == 2):
		if Input.is_action_pressed(diccionarioInputs[Enums.Arriba]):
			vectorVelocidad.y = -1
		if Input.is_action_pressed(diccionarioInputs[Enums.Abajo]):
			vectorVelocidad.y = 1
		if Input.is_action_pressed(diccionarioInputs[Enums.Abajo]) and Input.is_action_pressed(diccionarioInputs[Enums.Arriba])\
		or !Input.is_action_pressed(diccionarioInputs[Enums.Abajo]) and !Input.is_action_pressed(diccionarioInputs[Enums.Arriba]):
			vectorVelocidad.y = 0 
		if Input.is_action_pressed(diccionarioInputs[Enums.Izquierda]):
			vectorVelocidad.x = -1
		if Input.is_action_pressed(diccionarioInputs[Enums.Derecha]):
			vectorVelocidad.x = 1
		if Input.is_action_pressed(diccionarioInputs[Enums.Izquierda]) and Input.is_action_pressed(diccionarioInputs[Enums.Derecha])\
		or !Input.is_action_pressed(diccionarioInputs[Enums.Izquierda]) and !Input.is_action_pressed(diccionarioInputs[Enums.Derecha]):
			vectorVelocidad.x = 0
		# Enviar por rpc el vector velocidad
		Eventos.nuevoVectorRegistrado.emit(vectorVelocidad, jugador)
	position += vectorVelocidad * speed * delta
	#vectorVelocidad = Vector2.ZERO # intento
	
func perder_vida():
	if !canMove:
		return
	vida -= 1
	if vida == 2:
		$Sprite2D2.texture = \
		load("res://Sprites/QuickTimeEvent/brazoplapj1-2.png") \
		if jugador==1 else \
		load("res://Sprites/QuickTimeEvent/brazoplapj2-2.png")
		get_parent().reiniciar_pos()
	elif vida == 1:
		$Sprite2D2.texture = \
		load("res://Sprites/QuickTimeEvent/brazoplapj1-3.png") \
		if jugador==1 else \
		load("res://Sprites/QuickTimeEvent/brazoplapj2-3.png")
		get_parent().reiniciar_pos()
	if vida <= 0:
		$Sprite2D2.texture = \
		load("res://Sprites/QuickTimeEvent/brazoplapj1-4.png") \
		if jugador==1 else \
		load("res://Sprites/QuickTimeEvent/brazoplapj2-4.png")
		if jugador == 2:
			get_parent().puntajePj1 += 1
		else:
			get_parent().puntajePj2 += 1
		get_parent().pop_timer()
		
	
