extends Node2D

signal is_p2_hammer(bool) # la CPU necesita ésta señal para saber quién es
@onready var posicionesPosibles = [$Marker2D.position, $Marker2D2.position, \
$Marker2D3.position, $Marker2D4.position]
# El atacante puede ser el jugador 1 o el 2, luego cambian
var atacante
var defensor

var p2_started_as_hammer : bool # necesario para la CPU al inicio de la partida
var puntajePj1 = 0
var puntajePj2 = 0

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
	

func reiniciar_pos():
	var posDup = posicionesPosibles.duplicate()
	posDup.shuffle()
	
	$Martillo.position = posDup.pop_front()
	$Plato.position = posDup.pop_front()

func cambiar_roles():
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
	

func perderVidaPlato():
	$Plato.perder_vida()
	
func pop_timer():
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
