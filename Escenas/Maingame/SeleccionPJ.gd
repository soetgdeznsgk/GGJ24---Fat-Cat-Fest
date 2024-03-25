extends Node2D

var listaGatos = ["Random", "Miguel", "Timmy"]
var indexGatoSeleccionadoP1 = 0
var indexGatoSeleccionadoP2 = 0
var resourcesp1 = RecursosGatos.recursos[RecursosGatos.catSelectionP1]["mainGame"]
var resourcesp2 = RecursosGatos.recursos[RecursosGatos.catSelectionP2]["mainGame"]
# Called when the node enters the scene tree for the first time.

func _ready():
	if Eventos.multiOnline or Eventos.singleplayer:
		$SelectorGato2/FlechaIzquierda.visible = false
		$SelectorGato2/FlechaDerecha.visible = false

func _input(event):
	if !Eventos.multiOnline:
		if Input.is_action_just_pressed("IzquierdaPj1"):
			indexGatoSeleccionadoP1 -= 1
			if !listaGatos[indexGatoSeleccionadoP1%listaGatos.size()] == "Random":
				$SelectorGato1/Gato1.visible = true
				$SelectorGato1/Random.visible = false
				print(listaGatos[indexGatoSeleccionadoP1%listaGatos.size()])
				RecursosGatos.catSelectionP1 = listaGatos[indexGatoSeleccionadoP1%listaGatos.size()]
				resourcesp1 = RecursosGatos.recursos[RecursosGatos.catSelectionP1]["mainGame"]
				cambiarGato(1)
			else: 
				$SelectorGato1/Gato1.visible = false
				$SelectorGato1/Random.visible = true
				
		elif Input.is_action_just_pressed("DerechaPj1"):
			indexGatoSeleccionadoP1 += indexGatoSeleccionadoP1%listaGatos.size()
			if !listaGatos[indexGatoSeleccionadoP1%listaGatos.size()] == "Random":
				$SelectorGato1/Gato1.visible = true
				$SelectorGato1/Random.visible = false
				print(listaGatos[indexGatoSeleccionadoP1%listaGatos.size()])
				RecursosGatos.catSelectionP1 = listaGatos[indexGatoSeleccionadoP1%listaGatos.size()]
				resourcesp1 = RecursosGatos.recursos[RecursosGatos.catSelectionP1]["mainGame"]
				cambiarGato(1)
			else: 
				$SelectorGato1/Gato1.visible = false
				$SelectorGato1/Random.visible = true
				
		elif Input.is_action_just_pressed("IzquierdaPj2"):
			indexGatoSeleccionadoP2 -= 1
			if !listaGatos[indexGatoSeleccionadoP2%listaGatos.size()] == "Random":
				$SelectorGato2/Gato1.visible = true
				$SelectorGato2/Random.visible = false
				print(listaGatos[indexGatoSeleccionadoP2%listaGatos.size()])
				RecursosGatos.catSelectionP2 = listaGatos[indexGatoSeleccionadoP2%listaGatos.size()]
				resourcesp2 = RecursosGatos.recursos[RecursosGatos.catSelectionP2]["mainGame"]
				cambiarGato(2)
			else: 
				$SelectorGato2/Gato1.visible = false
				$SelectorGato2/Random.visible = true
				
		elif Input.is_action_just_pressed("DerechaPj2"):
			indexGatoSeleccionadoP2 += 1
			if !listaGatos[indexGatoSeleccionadoP2%listaGatos.size()] == "Random":
				$SelectorGato2/Gato1.visible = true
				$SelectorGato2/Random.visible = false
				print(listaGatos[indexGatoSeleccionadoP2%listaGatos.size()])
				RecursosGatos.catSelectionP2 = listaGatos[indexGatoSeleccionadoP2%listaGatos.size()]
				resourcesp2 = RecursosGatos.recursos[RecursosGatos.catSelectionP2]["mainGame"]
				cambiarGato(2)
			else: 
				$SelectorGato2/Gato1.visible = false
				$SelectorGato2/Random.visible = true
	if Input.is_action_just_pressed("ui_accept"):
		if indexGatoSeleccionadoP1%listaGatos.size() == 0:
			RecursosGatos.catSelectionP1 = listaGatos[randi_range(1, listaGatos.size() - 1)]
		if indexGatoSeleccionadoP2%listaGatos.size() == 0:
			RecursosGatos.catSelectionP2 = listaGatos[randi_range(1, listaGatos.size() - 1)]
		get_tree().change_scene_to_file("res://Escenas/Maingame/Versus.tscn")
			
func cambiarGato(jugador):
	match jugador:
		1:
			$SelectorGato1/Gato1.sprite_frames = resourcesp1["anims"]
			$SelectorGato1/Gato1.set_animation("idle")
			$SelectorGato1/Gato1.scale = resourcesp1["scale"]
			$SelectorGato1/Gato1.play()
		2:
			$SelectorGato2/Gato1.sprite_frames = resourcesp2["anims"]
			$SelectorGato2/Gato1.set_animation("idle")
			$SelectorGato2/Gato1.scale = resourcesp2["scale"]
			$SelectorGato2/Gato1.play()
