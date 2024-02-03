extends Node2D

signal p2_can_hit # señal para la IA

var diccionarioInputs := {}
@export var jugador = 1
@export var golpeando = false
@export var puedeGolpear = true
@onready var markerCabeza = $sprPadre/Marker2D2.position
@onready var cabeza = $sprPadre/Cabeza
@export var spriteCabeza : AnimatedSprite2D
@onready var cuerpo = $sprPadre/SprCuerpo
@onready var pata = $sprPadre/Pata
@onready var initialPos = pata.position
@onready var cabezaPosInicial = cabeza.position
@onready var sprArrow = $arrow
@onready var anim = $AnimationPlayer
var conteoGolpesRecibidos = 0
var enCooldown = false
var vida = 10
var lista_random_punch = [preload("res://Escenas/Eventos/darseduro/sfx/bonk.mp3"), preload("res://Escenas/Eventos/darseduro/sfx/puh.mp3"),\
preload("res://Escenas/Eventos/darseduro/sfx/thun.mp3")]
@export var random_offset : float = 0.1
var puedoRecibirHit = true
@export var sonidosPegar : Array[AudioStream]
var ultimoInputRegistrado = -1

func _ready() -> void:
	if jugador == 2:
		if !Eventos.multiOnline:
			diccionarioInputs[Enums.Arriba] = "ArribaPj2"
			diccionarioInputs[Enums.Abajo] = "AbajoPj2"
		else:
			diccionarioInputs[Enums.Arriba] = "ArribaPj1"
			diccionarioInputs[Enums.Abajo]  = "AbajoPj1"
		$Label.text = Names.name_player2
		$sprPadre.scale.x = -1
		$arrow.position.x*=-1
		$Label.modulate = Color("#F2DF6F")
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj1"
		$Label.text = Names.name_player1
		$Label.modulate = Color("#88D662")
	Eventos.enviarInput.connect(recibir_nuevo_input)

func recibir_nuevo_input(input, jugadorARecibir):
	if jugador == jugadorARecibir:
		ultimoInputRegistrado = input

func _physics_process(_delta: float) -> void:
	if !puedeGolpear:
		return
	
#region NO ONLINE INPUTS
	if !Eventos.multiOnline:
		if Input.is_action_just_pressed(diccionarioInputs[Enums.Arriba]):
			ultimoInputRegistrado = Enums.Arriba
			Eventos.nuevoInputRegistrado.emit(ultimoInputRegistrado, jugador)
		elif Input.is_action_just_pressed(diccionarioInputs[Enums.Abajo]):
			ultimoInputRegistrado = Enums.Abajo
			Eventos.nuevoInputRegistrado.emit(ultimoInputRegistrado, jugador)
#endregion
#region ONLINE INPUTS
	else:
		if (multiplayer.is_server() and jugador == 1) or (!multiplayer.is_server() and jugador == 2):
			if Input.is_action_just_pressed(diccionarioInputs[Enums.Arriba]):
				ultimoInputRegistrado = Enums.Arriba
				Eventos.nuevoInputRegistrado.emit(ultimoInputRegistrado, jugador)
			elif Input.is_action_just_pressed(diccionarioInputs[Enums.Abajo]):
				ultimoInputRegistrado = Enums.Abajo
				Eventos.nuevoInputRegistrado.emit(ultimoInputRegistrado, jugador)
#endregion
	if ultimoInputRegistrado == Enums.Arriba or \
	(jugador == 2 and Eventos.singleplayer and Input.is_action_pressed(diccionarioInputs[Enums.Arriba])):
		if golpeando and !enCooldown:
			sprArrow.play("down")
			golpeando = false
			enCooldown = true
			var tween = create_tween()
			tween.tween_property(pata,"position",$sprPadre/MarkerMediaPAta.position,0.1 + random_offset)
			tween.tween_property(pata,"position",initialPos,0.05 + (random_offset / 2))
			$TimerCooldown.start(0.09 + random_offset)
		else:
			anim.play("shake")
			sprArrow.visible=false
	if ultimoInputRegistrado == Enums.Abajo or \
	(jugador == 2 and Eventos.singleplayer and Input.is_action_pressed(diccionarioInputs[Enums.Abajo])):
		if !golpeando and !enCooldown:
			sprArrow.play("up")
			golpeando = true
			enCooldown = true
			var tween = create_tween()
			tween.tween_property(pata,"position",$sprPadre/MarkerMediaPAta.position,0.15)
			tween.tween_property(pata,"position",$sprPadre/MarkerFinalPAta.position,0.05)
			$TimerCooldown.start(0.15)
			sprArrow.visible=false
		else:
			anim.play("shake")

func _on_cabeza_area_entered(_area: Area2D) -> void:
	if puedoRecibirHit:
		$AudioStreamPlayer.stream = lista_random_punch.pick_random()
		$AudioStreamPlayer.play()
		spriteCabeza.play("bonk")
		#Recibe golpe
		conteoGolpesRecibidos += 1
		var tweenCabeza = get_tree().create_tween()
		tweenCabeza.set_ease(Tween.EASE_IN)
		tweenCabeza.tween_property(cabeza,"position", markerCabeza, 0.12)
		vida -= 1
		$VidaSprite.frame += 1
		puedoRecibirHit = false
		if vida == 0:
			get_parent().set_winner_by_life(jugador)

func _on_cabeza_area_exited(_area: Area2D) -> void:
	spriteCabeza.play("normal")
	var tweenCabeza = get_tree().create_tween()
	tweenCabeza.tween_property(cabeza,"position", cabezaPosInicial, 0.1)
	await get_tree().create_timer(0.2).timeout
	puedoRecibirHit = true

func _on_timer_cooldown_timeout() -> void:
	# TODO ajustar offset a lo que diga el testeo
	random_offset = randf_range(0, +0.3)
	enCooldown = false
	if jugador == 2:
		p2_can_hit.emit()
	sprArrow.visible=true
