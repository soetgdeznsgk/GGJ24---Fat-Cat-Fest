extends Node2D

signal is_p2_hammer(bool) # la CPU necesita ésta señal para saber quién es
@onready var posicionesPosiblesMartillo := [$Marker2DM1.position, $Marker2DM2.position, $Marker2DM3.position]
@onready var posicionesPosiblesPlato := [$Marker2DP1.position, $Marker2DP2.position, $Marker2DP3.position]
# El atacante puede ser el jugador 1 o el 2, luego cambian
var atacante
var defensor

var p2_started_as_hammer : bool # necesario para la CPU al inicio de la partida
var puntajePj1 = 0
var puntajePj2 = 0
var crack = preload("res://Escenas/Eventos/romperplatos/sfx/plato_crack.mp3")

func _ready() -> void:
	if randf() < 0.5:
		atacante = 1
		defensor = 2
	else:
		atacante = 2
		p2_started_as_hammer = true
		defensor = 1
	$Martillo.jugador = atacante
	$Plato.jugador = defensor
	$Martillo.cambiar_rol()
	$Plato.cambiar_rol()
	reiniciar_pos()
	

func reiniciar_pos() -> void:
	$Martillo.position = posicionesPosiblesMartillo.pick_random()
	$Plato.position = posicionesPosiblesPlato.pick_random()

func cambiar_roles() -> void:
	if atacante == 1:
		defensor = 1
		atacante = 2
	else:
		defensor = 2
		atacante = 1
	$Martillo.jugador = atacante
	$Plato.jugador = defensor
	$Martillo.cambiar_rol()
	$Plato.cambiar_rol()
	reiniciar_pos()
	$Martillo.canMove = true
	$Plato.canMove = true
	$TimerCambiarRoles.stop()
	

func perderVidaPlato() -> void:
	$AudioStreamPlayer.stream = crack
	$AudioStreamPlayer.play()
	$Plato.perder_vida()
	
func pop_timer() -> void:
	$Martillo.canMove = false
	$Martillo.anim.play("RESET")
	$Plato.canMove = false
	$AnimationPlayer.play("pop_numeros")

func _on_timer_final_evento_timeout() -> void:
	if puntajePj1 == puntajePj2:
		Eventos.finalEvento.emit(0)
	elif puntajePj1 > puntajePj2:
		Eventos.finalEvento.emit(1)
	elif puntajePj1 < puntajePj2:
		Eventos.finalEvento.emit(2)
	queue_free()
	
func relay_p2_position(b : bool) -> void:
	is_p2_hammer.emit(b)
