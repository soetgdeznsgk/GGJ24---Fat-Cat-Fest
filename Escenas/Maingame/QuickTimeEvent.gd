extends Node2D

@onready var anim = $AnimationPlayer
@onready var timer = $Timer

@onready var listaEventos : Array = [load("res://Escenas/Eventos/evento_romper_platos.tscn")]

func _ready():
	generarNuevoEvento()
	Eventos.finalEvento.connect(final_evento)
	
func tiempoAleatorio():
	return 200#randi_range(4,8) + randi_range(4,8)

func generarNuevoEvento():
	timer.start(tiempoAleatorio())

func _on_timer_timeout():
	anim.play("pop_up")
	# TODO acá cambiar el frame o textura de la campanita segun el evento
	Eventos.nuevoEvento.emit()

func finAnimacion():
	#logica de cambio de evento
	var eventoSeleccionado = listaEventos.pick_random()
	var eventoInstanciado = eventoSeleccionado.instantiate()
	# para testing usar el de abajo
	#var eventoSeleccionado = listaEventos[0]
	add_child(eventoInstanciado)
	
func final_evento(ganador):
	# TODO usar nombres de jugadores
	$Label.text = "Winner:\n" + "TENGO HAMBRE WEE"
	$AnimationPlayer.play("final_evento")
