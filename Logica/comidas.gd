extends Node2D
const recetasString = ["res://Escenas/Recetas/Empanada.tscn", "res://Escenas/Recetas/Salpicon.tscn",\
"res://Escenas/Recetas/Tamal.tscn", "res://Escenas/Recetas/BuñueloyNatilla.tscn","res://Escenas/Recetas/ArrozConLeche.tscn"]
var stackPlatos
var stackPlatos1
var stackPlatos2

#diccionario key: es el nombre de la receta(en la escena) 
#            value: nodo instanciado de la receta
var recetas1 :={}
var recetas2 :={}
var listaRecetasJugador1 =[]
var listaRecetasJugador2 =[]
var frameActualStackJugador1 = 0
var frameActualStackJugador2 = 0
var primerPlatoStack1 = true
var primerPlatoStack2 = true
@onready var recetaPlayer1=get_child(0)
@onready var recetaPlayer2=get_child(1)
@onready var brazoP1=recetaPlayer1.get_child(0)
@onready var brazoP2=recetaPlayer2.get_child(0)
var recetaActualJugador1
var recetaActualJugador2
var recogiendo=false

# Called when the node enters the scene tree for the first time.
func _ready():
	preloadRecetas()
	generarListaRecetas()
	stackPlatos = preload("res://Escenas/Recetas/Plato.tscn")
	Eventos.mediaComida.connect(cambiarSpriteMediaComida)
	Eventos.comidaAPuntoDeTerminar.connect(cambiarSpriteFinal)
	Eventos.comandosAcabados.connect(entradaReceta)
	Eventos.nuevoEvento.connect(pausarProcesos)
	Eventos.finalEvento.connect(reanudarProcesos)
	entradaReceta(1)
	entradaReceta(2)
	
func pausarProcesos(_cache):
	recetaActualJugador1.visible = false
	recetaActualJugador2.visible = false
	if stackPlatos1: stackPlatos1.visible = false
	if stackPlatos2: stackPlatos2.visible = false
	
func reanudarProcesos(_ganador):
	await get_tree().create_timer(3).timeout
	recetaActualJugador1.visible = true
	recetaActualJugador2.visible = true
	if stackPlatos1: stackPlatos1.visible = true
	if stackPlatos2: stackPlatos2.visible = true
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

func cambiar_sprite_stack(numeroJugadorActual):
	
	match numeroJugadorActual:
		1:
			if primerPlatoStack1:
				stackPlatos1 = stackPlatos.instantiate()
				stackPlatos1.set_position(Vector2(-90,-100))
				primerPlatoStack1 = false
				add_child(stackPlatos1)
				
			stackPlatos1.set_frame(frameActualStackJugador1)
			frameActualStackJugador1 += 1
		2:
			if primerPlatoStack2:
				stackPlatos2 = stackPlatos.instantiate()
				stackPlatos2.set_position(Vector2(90,-100))
				primerPlatoStack2 = false
				add_child(stackPlatos2)				
			stackPlatos2.set_frame(frameActualStackJugador2)
			frameActualStackJugador2 += 1
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
	for i in range(recetasString.size()):
		receta1 = recetas1.values()[rng.randi() % recetas1.size()]
		receta2 = recetas2.values()[rng.randi() % recetas2.size()]
		recetas1.erase(receta1.nombre)
		recetas2.erase(receta2.nombre)
		listaRecetasJugador1.append(receta1)
		listaRecetasJugador2.append(receta2)
#Hace la animacion de entrada, sacando de la pool, añade la receta en el punto de spawn y finalmente la anima
func entradaReceta(numeroJugador):
	match numeroJugador:
		1:
			sacar_siguiente_receta(numeroJugador)
			#instancia el brazo y lo añade
			if recetaActualJugador1!=null:
				recetaActualJugador1.position=Vector2(915,-300)
				brazoP1.add_child(recetaActualJugador1)
				animacion_entrada(1)
				#animacion_entrada_brazo(1)
			else:
				#print("ganoel1")
				Eventos.ganadorFestival.emit(numeroJugador)
		2:
			sacar_siguiente_receta(numeroJugador)	
			#
			if recetaActualJugador2!=null:
				recetaActualJugador2.position=Vector2(-915,-300)
				brazoP2.add_child(recetaActualJugador2)
				animacion_entrada(2)
			else:
				#print("ganoel2")
				Eventos.ganadorFestival.emit(numeroJugador)

func enviar_moveset(numeroJugador,recetamoveset):
	Eventos.nuevaComida.emit(numeroJugador,recetamoveset)
func sacar_siguiente_receta(numeroJugador):
	match numeroJugador:
		1:
			recetaActualJugador1 = listaRecetasJugador1.pop_back()
		2:
			recetaActualJugador2 = listaRecetasJugador2.pop_back()
func animacion_entrada(numeroJugador):
	#tween que mueve a la receta actual
	var tween=create_tween()
	tween.set_ease(Tween.EASE_IN)
	var brazoamover
	var direccionMov=Vector2.ZERO
	match numeroJugador:
		1:
			brazoamover=brazoP1
			direccionMov=Vector2(-130,300)
		2:
			brazoamover=brazoP2
			direccionMov=Vector2(130,300)
	tween.tween_property(brazoamover,"position",direccionMov,0.5)
	#tween.tween_property(recetaAMover,"position",direccionMov,.5)
	var recetahija=brazoamover.get_child(0)
	tween.tween_callback(enviar_moveset.bind(numeroJugador,recetahija.moveset))
	tween.tween_callback(animacion_salida.bind(numeroJugador))
	if recogiendo:
		tween.tween_callback(recoger.bind(numeroJugador))
	#tween.tween_callback(prueba.bind(recetaAMover))
	
func animacion_salida(numeroJugador):
	var hijoMesa
	var tween=create_tween()
	tween.set_ease(Tween.EASE_OUT)
	var brazoamover
	var direccionMov=Vector2.ZERO
	match numeroJugador:
		1:
			hijoMesa=brazoP1.get_child(0)
			brazoP1.remove_child(hijoMesa)
			recetaPlayer1.add_child(hijoMesa)
			hijoMesa.position=Vector2(830,0)
			brazoamover=brazoP1
			direccionMov=Vector2(-650,300)
		2:
			hijoMesa=brazoP2.get_child(0)
			brazoP2.remove_child(hijoMesa)
			recetaPlayer2.add_child(hijoMesa)
			hijoMesa.position=Vector2(-830,0)
			brazoamover=brazoP2
			direccionMov=Vector2(650,300)
	
	tween.tween_property(brazoamover,"position",direccionMov,.5)
	tween.tween_callback(empezar_a_recoger)
	if recogiendo:
		tween.tween_callback(cambiar_sprite_stack.bind(numeroJugador))
	

func empezar_a_recoger():
	recogiendo=true 
func recoger(numeroJugador):
	var recetaallevar
	match numeroJugador:
		1:
			recetaallevar=recetaPlayer1.get_child(1)
			recetaPlayer1.remove_child(recetaallevar)
			brazoP1.add_child(recetaallevar)
			recetaallevar.position=Vector2(915,-300)
			brazoP1.remove_child(recetaallevar)
		2:
			recetaallevar=recetaPlayer2.get_child(1)
			recetaPlayer2.remove_child(recetaallevar)
			brazoP2.add_child(recetaallevar)
			recetaallevar.position=Vector2(-915,-300)
			brazoP2.remove_child(recetaallevar)
			

