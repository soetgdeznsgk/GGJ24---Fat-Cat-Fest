extends Node2D
const recetasString = ["res://Escenas/Recetas/ArrozConLeche.tscn",\
"res://Escenas/Recetas/Empanada.tscn", "res://Escenas/Recetas/Salpicon.tscn",\
"res://Escenas/Recetas/Tamal.tscn", "res://Escenas/Recetas/BuñueloyNatilla.tscn"]
const recetasSize=5
#diccionario key: es el nombre de la receta(en la escena) 
#            value: nodo instanciado de la receta
var recetas1 :={}
var recetas2 :={}
var listaRecetasJugador1 =[]
var listaRecetasJugador2 =[]
@onready var recetaPlayer1=get_child(0)
@onready var recetaPlayer2=get_child(1)
var recetaActualJugador1
var recetaActualJugador2

# Called when the node enters the scene tree for the first time.
func _ready():

	preloadRecetas()
	generarListaRecetas()
	Eventos.mediaComida.connect(cambiarSpriteMediaComida)
	Eventos.comidaAPuntoDeTerminar.connect(cambiarSpriteFinal)
	Eventos.comandosAcabados.connect(entradaReceta)
	entradaReceta(1)
	entradaReceta(2)
func cambiarSpriteMediaComida(numeroJugadorActual):
	match numeroJugadorActual:
		1:
			recetaActualJugador1.set_frame(1)
		2:
			recetaActualJugador2.set_frame(1)
func cambiarSpriteFinal(numeroJugadorActual):
	match numeroJugadorActual:
		1:
			recetaActualJugador1.set_frame(2)
		2:
			recetaActualJugador2.set_frame(2)

#carga todas las recetas y las coloca en el diccionario pal jugador 1 y 2
func preloadRecetas():

	var recetainstanciada
	var recetainstanciada1
	var recetainstanciada2
	for receta in recetasString:
		recetainstanciada=load(receta)
		recetainstanciada1=recetainstanciada.instantiate()
		recetainstanciada2=recetainstanciada.instantiate()
		recetas1[recetainstanciada1.nombre]=recetainstanciada1
		recetas2[recetainstanciada2.nombre]=recetainstanciada2
	

func generarListaRecetas():
	var rng = RandomNumberGenerator.new()
	var receta1
	var receta2
	for i in range(recetasSize):
		#ARREGLAR COSO
		receta1 = recetas1.values()[rng.randi() % recetas1.size()]
		receta2 = recetas2.values()[rng.randi() % recetas2.size()]
		recetas1.erase(receta1.nombre)
		recetas2.erase(receta2.nombre)
		listaRecetasJugador1.append(receta1)
		listaRecetasJugador2.append(receta2)

func entradaReceta(numeroJugador):
	match numeroJugador:
		1:
			if recetaActualJugador1!=null:
				animacion_salida(1)
			recetaActualJugador1 = listaRecetasJugador1.pop_back()
			if recetaActualJugador1!=null:
				recetaPlayer1.add_child(recetaActualJugador1)
				animacion_entrada(1)
			else:
				print("aca se manda a que el P1 gane el juego")
		2:
			if recetaActualJugador2!=null:
				animacion_salida(2)
			recetaActualJugador2 = listaRecetasJugador2.pop_back()
			
			if recetaActualJugador2!=null:
				recetaPlayer2.add_child(recetaActualJugador2)
				animacion_entrada(2)
			else:
				print("aca se manda a que el P2 gane el juego")

func enviar_moveset(numeroJugador,recetamoveset):
	Eventos.nuevaComida.emit(numeroJugador,recetamoveset)
func cambiarframe():
	recetaActualJugador1.set_frame(0)
func animacion_entrada(numeroJugador):
	#tween que mueve a la receta actual
	var tween=create_tween()
	var recetaAMover
	var direccionMov=Vector2.ZERO
	match numeroJugador:
		1:
			recetaAMover=recetaActualJugador1
			direccionMov=Vector2(790,0)
		2:
			recetaAMover=recetaActualJugador2
			direccionMov=Vector2(-790,0)
	#print(recetaActual.moveset)
	
	tween.tween_property(recetaAMover,"position",direccionMov,1)
	tween.tween_callback(enviar_moveset.bind(numeroJugador,recetaAMover.moveset))
	tween.tween_callback(cambiarframe)
	#tween.tween_callback(prueba.bind(recetaAMover))
	

func animacion_salida(numeroJugador):
	var tween=create_tween()
	var recetaAMover
	var direccionMov=Vector2.ZERO
	match numeroJugador:
		1:
			recetaAMover=recetaActualJugador1
			direccionMov=Vector2(0,0)
		2:
			recetaAMover=recetaActualJugador2
			direccionMov=Vector2(0,0)
	tween.tween_property(recetaAMover,"position",direccionMov,1)
	tween.tween_callback(recetaAMover.queue_free)
