extends Node2D

@onready var anim = $AnimationPlayer
@onready var timer = $Timer
@onready var listaEventos : Array = [ # CRITICAL no cambiar el orden de los eventos, el enum Eventos.MiniJuegos está ordenado igual
preload("res://Escenas/Eventos/romperplatos/evento_romper_platos.tscn"),
preload("res://Escenas/Eventos/pepino/evento_pepino.tscn"),
preload("res://Escenas/Eventos/darseduro/evento_darse_duro.tscn")
]

var lista_random_sfx_go = [preload("res://Escenas/Eventos/SFX/miauGo.mp3"), preload("res://Escenas/Eventos/SFX/gouu.mp3"),\
 preload("res://Escenas/Eventos/SFX/miauugo.mp3")]

var lista_random_count = [preload("res://Escenas/Eventos/SFX/miauth1.mp3"), preload("res://Escenas/Eventos/SFX/miauth2.mp3"),\
preload("res://Escenas/Eventos/SFX/miau3th.mp3"), preload("res://Escenas/Eventos/SFX/miauGrave.mp3")]

var lista_campana = [preload("res://Escenas/Eventos/SFX/campanita.mp3"), preload("res://Escenas/Eventos/SFX/campanita2.mp3")]

var lista_gato_anuncia = [preload("res://Escenas/Eventos/SFX/gatoanunciagrave.mp3"), preload("res://Escenas/Eventos/SFX/randomGatoAnuncia.mp3")]

func _ready():
	generarNuevoEvento()
	Eventos.finalEvento.connect(final_evento)
	Eventos.ganadorFestival.connect(finJuego)

func finJuego(_ganador):
	anim.play("fin_juego")
	
func tiempoAleatorio():
	return 5# randi_range(15,20) + randi_range(15,20) #return 2

func generarNuevoEvento():
	timer.start(tiempoAleatorio())

func _on_timer_timeout():
	anim.play("pop_up")

func cheer(prob : float):
	Eventos.catCheer.emit(prob)

func finAnimacion():
	#logica de cambio de evento
	var selection = randi_range(0,0)#, listaEventos.size() - 1)
	# para testing usar el de abajo
	#var selection = listaEventos[0]
	var eventoInstanciado = listaEventos[selection].instantiate()
	add_child(eventoInstanciado)
	Eventos.nuevoEvento.emit(selection) # ésto es lo que le dice a la CPU
	
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
