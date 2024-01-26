extends Node2D

@onready var anim = $AnimationPlayer
@onready var timer = $Timer
@onready var listaEventos : Array = [
load("res://Escenas/Eventos/romperplatos/evento_romper_platos.tscn"),
load("res://Escenas/Eventos/pepino/evento_pepino.tscn"),
load("res://Escenas/Eventos/darseduro/evento_darse_duro.tscn")
]

var lista_random_sfx_go = [load("res://Escenas/Eventos/SFX/miauGo.mp3"), load("res://Escenas/Eventos/SFX/gouu.mp3"),\
 load("res://Escenas/Eventos/SFX/miauugo.mp3")]

var lista_random_count = [load("res://Escenas/Eventos/SFX/miauth1.mp3"), load("res://Escenas/Eventos/SFX/miauth2.mp3"),\
load("res://Escenas/Eventos/SFX/miau3th.mp3"), load("res://Escenas/Eventos/SFX/miauGrave.mp3")]

var lista_campana = [load("res://Escenas/Eventos/SFX/campanita.mp3"), load("res://Escenas/Eventos/SFX/campanita2.mp3")]

var lista_gato_anuncia = [load("res://Escenas/Eventos/SFX/gatoanunciagrave.mp3"), load("res://Escenas/Eventos/SFX/randomGatoAnuncia.mp3")]

func _ready():
	generarNuevoEvento()
	Eventos.finalEvento.connect(final_evento)
	
func tiempoAleatorio():
	return randi_range(15,20) + randi_range(15,20) #return 2

func generarNuevoEvento():
	timer.start(tiempoAleatorio())

func _on_timer_timeout():
	anim.play("pop_up")
	Eventos.nuevoEvento.emit()

func cheer(prob : float):
	Eventos.catCheer.emit(prob)

func finAnimacion():
	#logica de cambio de evento
	var eventoSeleccionado = listaEventos.pick_random()
	# para testing usar el de abajo
	#var eventoSeleccionado = listaEventos[1]
	var eventoInstanciado = eventoSeleccionado.instantiate()
	add_child(eventoInstanciado)
	
func final_evento(ganador):
	var texto = "Winner:\n"
	if ganador == 0:
		texto = "None, GIT GUD"
	elif ganador == 1:
		texto += Names.name_player1
	elif ganador == 2:
		texto += Names.name_player2
	$Label.text = texto
	$AnimationPlayer.play("final_evento")
	generarNuevoEvento()

func set_sfx_random_go():
	select_random_sfx_from_pool($AudioStreamPlayer, lista_random_sfx_go)

func set_sfx_random_count():
	select_random_sfx_from_pool($AudioStreamPlayer, lista_random_count)

func set_sfx_random_campana():
	select_random_sfx_from_pool($AudioStreamPlayer, lista_campana)

func set_sfx_random_anuncia():
	select_random_sfx_from_pool($AudioStreamPlayer, lista_gato_anuncia)

func select_random_sfx_from_pool(sfx : AudioStreamPlayer, pool : Array):
	var selected = pool.pick_random()
	sfx.stream = selected
