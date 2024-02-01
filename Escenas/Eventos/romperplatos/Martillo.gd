extends Area2D

signal is_p2_hammer(bool)
var golpeando = false
var platoAqui = false
@export var jugador = 1
var diccionarioInputs := {}
@onready var anim = $AnimationPlayer
@export var speed : int = 30
var canMove = true
var vectorVelocidad : Vector2

func _ready() -> void:
	Eventos.enviarVector.connect(recibir_nuevo_input)

func recibir_nuevo_input(vector, jugadorARecibir):
	if jugador == jugadorARecibir:
		vectorVelocidad = vector

func set_golpeando(golpe):
	golpeando = golpe

func cambiar_rol():
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
		$Label.text = Names.name_player2
		$Label.modulate = Color("#F2DF6F")
		is_p2_hammer.emit(true)
		anim.play("MartillandoP2")
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj1"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj1"
		diccionarioInputs[Enums.Derecha] = "DerechaPj1"
		$Label.text = Names.name_player1
		$Label.modulate = Color("#88D662")
		is_p2_hammer.emit(false)
		anim.play("MartillandoP1")
	golpeando = false
	platoAqui = false
	
	

func _physics_process(delta: float) -> void:
	if !canMove:
		return
		
	if position.y < 50:
		position.y = 50
	if position.y > 620:
		position.y = 620
	if position.x < 100:
		position.x = 100
	if position.x > 1200:
		position.x = 1200
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
	position += vectorVelocidad.normalized() * speed * delta
	#vectorVelocidad = Vector2.ZERO # intento
	
	if platoAqui and golpeando:
		get_parent().perderVidaPlato()
	

func _on_area_entered(_area: Area2D) -> void:
	platoAqui = true

func _on_area_exited(_area: Area2D) -> void:
	platoAqui = false
