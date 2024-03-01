extends Node2D

signal p2_can_hit # señal para la IA

var diccionarioInputs := {}
@export var jugador = 1
@export var golpeando = false
@export var puedeGolpear = true
@onready var cabeza = $sprPadre/Cabeza
@onready var cuerpo = $sprPadre/SprCuerpo
@onready var pata = $sprPadre/Pata
@onready var initialPos = pata.position
@onready var cabezaPosInicial = cabeza.position
var markerCabeza
@onready var sprArrow = $arrow
@onready var anim = $AnimationPlayer
@onready var soundP = $AudioStreamPlayer

@onready var sprCabeza = $sprPadre/Cabeza/SprCabeza
@onready var sprPata = $sprPadre/Pata/SprPata
@onready var sprCuerpo = $sprPadre/SprCuerpo

var conteoGolpesRecibidos = 0
var enCooldown = false
var vida = 10
var lista_random_punch = Globals.loadResources("res://SFX/QuickTimeEvents/DarseDuro/")

@export var random_offset : float = 0.1
var puedoRecibirHit = true
var ultimoInputRegistrado = -1

var resources

func _ready() -> void:
	
	resources = RecursosGatos.recursos[RecursosGatos.catSelectionP1 if jugador == 1 else \
				   						  RecursosGatos.catSelectionP2]["darseDuro"]
	
	var resourcesPata = resources["Pata"]
	sprPata.texture = resourcesPata["sprite"]
	sprPata.scale = resourcesPata["scale"]
	
	var resourcesCuerpo = resources["Cuerpo"]
	sprCuerpo.texture = resourcesCuerpo["sprite"]
	sprCuerpo.position = resourcesCuerpo["pos"]
	sprCuerpo.scale = resourcesCuerpo["scale"]
	
	var resourcesCabeza = resources["Cabeza"]
	sprCabeza.texture = resourcesCabeza["CabezaNormal"]
	sprCabeza.position = resourcesCabeza["pos"]
	sprCabeza.scale = resourcesCabeza["scale"]
	markerCabeza =  resourcesCabeza["markerDown"]
	
	sprArrow.play("down")
	
	if jugador == 2:
		diccionarioInputs[Enums.Arriba] = "ArribaPj2" if !Eventos.multiOnline else "ArribaPj1"
		diccionarioInputs[Enums.Abajo] = "AbajoPj2" if !Eventos.multiOnline else "AbajoPj1"
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj1"
		
	$sprPadre.scale.x *= -1 if jugador == 2 else 1
	$arrow.position.x *= -1 if jugador == 2 else 1
	
	Eventos.enviarInput.connect(recibir_nuevo_input)

func recibir_nuevo_input(input, jugadorARecibir):
	if jugador == jugadorARecibir:
		ultimoInputRegistrado = input

func _physics_process(_delta: float) -> void:
	if !puedeGolpear: return
	
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
			sprArrow.visible=false
		else:
			if enCooldown: anim.play("shake")

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
			if enCooldown: anim.play("shake")

func _on_cabeza_area_entered(_area: Area2D) -> void:
	if puedoRecibirHit:
		Globals.playRandomSound(soundP, lista_random_punch)
		sprCabeza.texture = resources["Cabeza"]["CabezaHit"]
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
	sprCabeza.texture = resources["Cabeza"]["CabezaNormal"]
	var tweenCabeza = get_tree().create_tween()
	tweenCabeza.tween_property(cabeza,"position", cabezaPosInicial, 0.1)
	await get_tree().create_timer(0.2).timeout
	puedoRecibirHit = true

func _on_timer_cooldown_timeout() -> void:
	# TODO ajustar offset a lo que diga el testeo
	random_offset = randf_range(0, +0.3)
	enCooldown = false
	if jugador == 2: p2_can_hit.emit()
	sprArrow.visible=true
