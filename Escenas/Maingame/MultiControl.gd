extends Node
@export var comidas : Node

func _ready() -> void:
	if !Eventos.multiOnline:
		queue_free()
		return
	Eventos.nuevoInputRegistrado.connect(push_new_input_rpc)
	Eventos.nuevoVectorRegistrado.connect(push_new_vector_rpc)
	comidas.comidaListaGenerada.connect(sync_comidas_rpc)

func sync_comidas_rpc(lista1,lista2):
	# Solo el server dirá que comidas hay
	if multiplayer.is_server():
		sync_comidas.rpc(lista1,lista2)

@rpc("authority","reliable","call_local")
func sync_comidas(lista1,lista2):
	comidas.sincronizarRecetas(lista1,lista2)
	# Mete las comidas del server
	comidas.entradaReceta(1)
	comidas.entradaReceta(2)

func push_new_input_rpc(input, jugador):
	push_new_input.rpc(input, jugador)

func push_new_vector_rpc(vector, jugador):
	push_new_vector.rpc(vector, jugador)

@rpc("any_peer","reliable","call_local")
func push_new_input(input, jugador):
	if Eventos.ganador == 0 :
		Eventos.enviarInput.emit(input, jugador)

@rpc("any_peer","reliable","call_local")
func push_new_vector(vector, jugador):
	if Eventos.ganador == 0 :
		Eventos.enviarVector.emit(vector, jugador)




