extends Node2D

@onready var anim = $AnimationPlayer
@onready var timer = $Timer

var listaEventos : Array[PackedScene] = [load("res://Escenas/Eventos/evento_romper_platos.tscn")]

func _ready():
	generarNuevoEvento()
	
func tiempoAleatorio():
	return 8#randi_range(10,20) + randi_range(10,20)

func generarNuevoEvento():
	timer.start(tiempoAleatorio())

func _on_timer_timeout():
	anim.play("pop_up")
	Eventos.nuevoEvento.emit()

func finAnimacion():
	#logica de cambio de evento
	var eventoSeleccionado = listaEventos.pick_random().instantiate()
	add_child(eventoSeleccionado)
	
