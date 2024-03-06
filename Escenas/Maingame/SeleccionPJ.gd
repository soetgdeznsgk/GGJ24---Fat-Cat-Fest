extends Node2D

var listaGatos = ["Random", "Miguel", "Timmy"]
var indexGatoSeleccionadoP1 = 0
var indexGatoSeleccionadoP2 = 0
var resourcesp1 = RecursosGatos.recursos[RecursosGatos.catSelectionP1]["mainGame"]
var resourcesp2 = RecursosGatos.recursos[RecursosGatos.catSelectionP2]["mainGame"]
var diccionarioInputs := {}
# Called when the node enters the scene tree for the first time.



func _input(event):
	if !Eventos.multiOnline:
		if Input.is_action_just_pressed("IzquierdaPj1"):
			indexGatoSeleccionadoP1 -= 1
			cambiarGato(1)
			print(listaGatos[indexGatoSeleccionadoP1%listaGatos.size()])
		elif Input.is_action_just_pressed("DerechaPj1"):
			indexGatoSeleccionadoP1 += 1
			cambiarGato(1)			
			print(listaGatos[indexGatoSeleccionadoP1%listaGatos.size()])
		
	pass

func cambiarGato(jugador):
	match jugador:
		1:
			if listaGatos[indexGatoSeleccionadoP1%listaGatos.size()] == "Random":
				$SelectorGato1/Gato1.play("default")
			else:
				$SelectorGato1/Gato1.sprite_frames = resourcesp1["anims"]
				$SelectorGato1/Gato1.scale = resourcesp1["scale"]
	
