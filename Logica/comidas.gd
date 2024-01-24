extends Node2D
enum {LEFT, RIGHT, UP, DOWN}
const recetasString = ["res://Escenas/Recetas/Buñuelo.tscn",\
"res://Escenas/Recetas/Empanana.tscn"]
const recetasSize=2
#var receta1=preload(string)
#var nodoinstanciado=receta1.instantiate()
var nodoinstanciado2=preload("res://Escenas/Recetas/Empanana.tscn").instantiate()
#diccionario key: es el nombre de la receta(en la escena) 
#            value: nodo instanciado de la receta
var recetas1 :={}
var recetas2 :={}
var listaRecetasJugador1 =[]
var listaRecetasJugador2 =[]

# Called when the node enters the scene tree for the first time.
func _ready():
	preloadRecetas()
	generarListaRecetas()
	print("1")
	print(listaRecetasJugador1)
	print("2")
	print(listaRecetasJugador2)
	var recetaActualJugador1 = listaRecetasJugador1.pop_back()
	var recetaActualJugador2 = listaRecetasJugador2.pop_back()

	get_child(0).add_child(recetaActualJugador1)
	get_child(1).add_child(recetaActualJugador2)
	animacion_entrada(1)
	animacion_entrada(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass
#funcion que cuando se llama se dice si es para el jugador 1 o 2 (0=p1,  1=p2)
func animacion_entrada(player):
	var tween=create_tween()
	var recetaActual
	var direccionMov=Vector2.ZERO
	if player==0:
		recetaActual=get_child(0).get_child(0)
		direccionMov=Vector2(700,0)
	else:
		recetaActual=get_child(1).get_child(0)
		direccionMov=Vector2(-700,0)
	#print(recetaActual.moveset)
	tween.tween_property(recetaActual,"position",direccionMov,1)
	#tween que mueve a la receta actual

func preloadRecetas():
	var recetainstanciada
	#carga todas las recetas y las coloca en el diccionario
	for receta in recetasString:
		
		recetainstanciada=load(receta).instantiate()
		recetas1[recetainstanciada.nombre]=recetainstanciada
	recetas2=recetas1.duplicate()

func generarListaRecetas():
	var rng = RandomNumberGenerator.new()
	var listaRecetas = []
	print(recetas1)
	var recetaActual1
	var recetaActual2
	for i in range(recetasSize):
		recetaActual1 = recetas1.values()[rng.randi_range(0, recetas1.size() - 1)]
		recetaActual2 = recetas2.values()[rng.randi_range(0, recetas2.size() - 1)]
		#print("1")
		#print(recetaActual1)
		#print("2")
		#print(recetaActual2)
		listaRecetasJugador1.append(recetaActual1)
		listaRecetasJugador2.append(recetaActual2)
