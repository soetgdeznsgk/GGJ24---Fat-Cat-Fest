extends Node

@export var gato1Comandos : Node
@export var gato2Comandos : Node
@export var comidas : Node
@export var inputBuffer : Array = []
var comandoGato2

func _ready() -> void:
	if !Eventos.multiOnline:
		queue_free()
		return
	gato1Comandos.nuevoInputRegistrado.connect(push_new_input_rpc)
	comidas.comidaListaGenerada.connect(sync_comidas_rpc)

func sync_comidas_rpc(lista1,lista2):
	# Solo el server dirá que comidas hay
	if multiplayer.is_server():
		sync_comidas.rpc(lista1,lista2)

@rpc("authority","reliable","call_local")
func sync_comidas(lista1,lista2):
	comidas.sincronizarRecetas(lista1,lista2)
	# Mete las comidas del server
	# Si es cliente usará la lista 2
	if !multiplayer.is_server():
		var swap = comidas.listaRecetasJugador2
		comidas.listaRecetasJugador2 = comidas.listaRecetasJugador1
		comidas.listaRecetasJugador1 = swap
	comidas.entradaReceta(1)
	comidas.entradaReceta(2)

func push_new_input_rpc(input):
	if multiplayer.is_server():
		push_new_input.rpc_id(MultiplayerControl.clientId,input)
	else:
		push_new_input.rpc_id(MultiplayerControl.hostingId,input)

@rpc("any_peer","reliable","call_local")
func push_new_input(input):
	# no se resetea eventos ganador despues de ganar
	if Eventos.ganador == 0:
		gato2Comandos.ultimoInputRegistrado = input
	
	#if jugador == 1:
		#inputBufferHost.append(input)
		#print('hoster ', inputBufferHost)
	#else:
		#inputBufferClient.append(input)
		#print('clienter ', inputBufferClient)

func _physics_process(delta: float) -> void:
	#if MultiplayerControl.isHost and \
	#gato2Comandos.permitirEntradas and \
	#inputBufferClient.size() > 0:
		#gato2Comandos.ultimoInputRegistrado = inputBufferClient.pop_front()
	#if !MultiplayerControl.isHost and \
	#gato2Comandos.permitirEntradas and \
	#inputBufferHost.size() > 0:
		#gato2Comandos.ultimoInputRegistrado = inputBufferHost.pop_front()
	pass
