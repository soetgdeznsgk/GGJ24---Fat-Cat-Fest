extends Node2D
const recetasString = ["res://Escenas/Recetas/Buñuelo.tscn",\
"res://Escenas/Recetas/Empanana.tscn"]
const recetasSize=2
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
	entradaReceta()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		salidaReceta()
	pass
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
	var listaRecetas = []
	print(recetas1)
	var receta1
	var receta2
	for i in range(recetasSize):
		#ARREGLAR COSO
		receta1 = recetas1.values()[rng.randi_range(0, recetas1.size() - 1)]
		receta2 = recetas2.values()[rng.randi_range(0, recetas2.size() - 1)]
		listaRecetasJugador1.append(receta1)
		listaRecetasJugador2.append(receta2)

func manejarCambioReceta():
	if recetaPlayer1.get_child_count() == 0:
		entradaReceta()
	else:
		salidaReceta()

func entradaReceta():
	recetaActualJugador1 = listaRecetasJugador1.pop_back()
	recetaActualJugador2 = listaRecetasJugador2.pop_back()
	print(listaRecetasJugador1)
	recetaPlayer1.add_child(recetaActualJugador1)
	recetaPlayer2.add_child(recetaActualJugador2)
	
	recetaActualJugador1.get_child(0).play("EntrandoP1")
	recetaActualJugador2.get_child(0).play("EntrandoP2")

# por alguna razon esto no funciona
func salidaReceta():
	recetaActualJugador1.getchild(0).play_backwards("EntrandoP1")
	recetaActualJugador2.getchild(0).play_backwards("EntrandoP2")
	recetaActualJugador1.getchild(0).animation_finished().connect(prueba1)
	recetaActualJugador2.getchild(0).animation_finished().connect(prueba2)
	
func prueba1():
	recetaPlayer1.remove_child(recetaActualJugador1)

func prueba2():
	recetaPlayer2.remove_child(recetaActualJugador2)
	
