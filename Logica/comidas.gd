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
	if Input.is_action_just_pressed("ui_accept"):
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
	print("hola")

func entradaReceta():
	recetaActualJugador1 = listaRecetasJugador1.pop_back()
	recetaActualJugador2 = listaRecetasJugador2.pop_back()
	print(listaRecetasJugador1)
	recetaPlayer1.add_child(recetaActualJugador1)
	recetaPlayer2.add_child(recetaActualJugador2)
	animacion_entrada(1)
	animacion_entrada(2)

# por alguna razon esto no funciona
func salidaReceta():
	#recetaActualJugador1.get_child(0).play_backwards("EntrandoP1")
	#recetaActualJugador2.get_child(0).play_backwards("EntrandoP1")
	animacion_salida(1)
	animacion_salida(2)
	#animation_finished es una funcion, como se está conectando se pone sin parentesis (para poner la referencia)
	#recetaActualJugador1.get_child(0).animation_finished.connect(prueba1)
	#recetaActualJugador2.get_child(0).animation_finished.connect(prueba2)
	
func prueba(receta):
	print("HOLA CHAT ESTOY ENTRANDOOOOOOOOOOOOOOO  SOY ",receta)

func animacion_entrada(numeroJugador):
	#tween que mueve a la receta actual
	var tween=create_tween()
	var recetaAMover
	var direccionMov=Vector2.ZERO
	match numeroJugador:
		1:
			recetaAMover=recetaActualJugador1
			direccionMov=Vector2(700,0)
		2:
			recetaAMover=recetaActualJugador2
			direccionMov=Vector2(-700,0)
	#print(recetaActual.moveset)
	tween.tween_property(recetaAMover,"position",direccionMov,1)
	tween.tween_callback(prueba.bind(recetaAMover))
	tween.tween_callback(queue_free)
	

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
	#print(recetaActual.moveset)
	tween.tween_property(recetaAMover,"position",direccionMov,1)
	recetaAMover.queue_free()
