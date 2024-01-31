extends Node

@export var gato1Comandos : Node
@export var gato2Comandos : Node


@export var inputBufferClient : Array = []
@export var inputBufferHost : Array = []
var comando1
var comando2

func _ready() -> void:
	print("es multi?", Eventos.multiOnline)
	if !Eventos.multiOnline:
		queue_free()
		return
	#gato1Comandos.llegaronComandos.connect(push_new_set_rpc)
	gato1Comandos.nuevoInputRegistrado.connect(push_new_input_rpc)

func push_new_input_rpc(input):
	if multiplayer.is_server():
		push_new_input.rpc_id(MultiplayerControl.clientId,input)
	else:
		push_new_input.rpc_id(MultiplayerControl.hostingId,input)
	

func push_new_set_rpc(comandos):
	if multiplayer.is_server():
		comando1 = comandos
	else:
		comando2 = comandos
	#push_new_set.rpc()

func push_new_set():
	pass


@rpc("any_peer","reliable","call_local")
func push_new_input(input):
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
		#
	pass
