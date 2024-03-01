extends Node2D

@onready var anim = $AnimationPlayer
@onready var timer = $Timer
@onready var listaEventos : Array = [ # CRITICAL no cambiar el orden de los eventos, el enum Eventos.MiniJuegos está ordenado igual
preload("res://Escenas/Eventos/romperplatos/evento_romper_platos.tscn"),
preload("res://Escenas/Eventos/pepino/evento_pepino.tscn"),
preload("res://Escenas/Eventos/darseduro/evento_darse_duro.tscn")
]

var lista_random_sfx_go = Globals.loadResources("res://SFX/QuickTimeEvents/Go/")
var lista_random_count = Globals.loadResources("res://SFX/QuickTimeEvents/Countdown/")
var lista_campana = Globals.loadResources("res://SFX/QuickTimeEvents/Campana/")
var lista_gato_anuncia = Globals.loadResources("res://SFX/QuickTimeEvents/Announcer/")

var ultimoEvento 
var selection 

func _ready():
	if !Eventos.multiOnline or multiplayer.is_server():
		generarNuevoEvento()
	Eventos.finalEvento.connect(final_evento)
	Eventos.ganadorFestival.connect(finJuego)

func finJuego(_ganador):
	timer.stop()
	anim.play("fin_juego")

func tiempoAleatorio():
	# TEST 
	#return 5
	if Eventos.singleplayer:
		match Eventos.cpuDiff:
			1:
				return randi_range(12,16)
			2:
				return randi_range(10,14)
			3: 
				return randi_range(8,12)
	else:
		return randi_range(8,12) if !Eventos.multiOnline else randi_range(10,14)

func generarNuevoEvento():
	timer.start(tiempoAleatorio())

@rpc("authority","call_remote","reliable")
func set_selection(selectionFromServer):
	selection = selectionFromServer
	match selection:
		0:
			$LabelCualEventoEs.text = "Plate Breaker"
		1:
			$LabelCualEventoEs.text = "Hot Cucumber"
		2:
			$LabelCualEventoEs.text = "Cat Fight"
	anim.play("pop_up")
	Eventos.bajarTelon.emit()

func _on_timer_timeout():
	#logica de cambio de evento
	selection = randi_range(0,listaEventos.size() - 1)
	# TEST
	#selection = 2
	if selection == ultimoEvento:
		if selection < 2:
			selection += 1
		elif selection == 2:
			selection = 0
	if Eventos.multiOnline:
		set_selection.rpc_id(MultiplayerControl.clientId,selection)
	match selection:
		0:
			$LabelCualEventoEs.text = "Plate Breaker"
		1:
			$LabelCualEventoEs.text = "Hot Cucumber"
		2:
			$LabelCualEventoEs.text = "Cat Fight"
	anim.play("pop_up")
	Eventos.bajarTelon.emit()

func cheer(prob : float):
	Eventos.catCheer.emit(prob)

func finAnimacion():
	if !Eventos.multiOnline:
		var eventoInstanciado = listaEventos[selection].instantiate()
		ultimoEvento = selection 
		add_child(eventoInstanciado)
		Eventos.nuevoEvento.emit(selection) # ésto es lo que le dice a la CPU
	else:
		if multiplayer.is_server():
			finAnimacionRpc.rpc()

@rpc("authority","call_local","reliable")
func finAnimacionRpc():
	var eventoInstanciado = listaEventos[selection].instantiate()
	ultimoEvento = selection 
	add_child(eventoInstanciado)
	Eventos.nuevoEvento.emit(selection)

func final_evento(ganador):
	var texto = "Winner:\n"
	if ganador == 0:
		texto = "No one!, GIT GUD"
	elif ganador == 1:
		texto += Names.name_player1
	elif ganador == 2:
		texto += Names.name_player2
	$Label.text = texto
	$AnimationPlayer.play("final_evento")
	if !Eventos.multiOnline or multiplayer.is_server():
		generarNuevoEvento()

#region SFX

# Esto lo iba a cambiar pero solo Dios y sebas sabía como servía esto
# ahora solo Dios

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

#endregion
